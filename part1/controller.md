### Some Controller

There is a lot to be improved in this controller action. My guess is the person who wrote this code comes from a strong procedural language background, and may not be comfortable with the idea of objects. The only classes used in this controller action are models.

The first thing I would suggest is to extract methods and replace snippits of code with meaningful names. In its current form, this code does not do a good job of revealing intent. Extracting methods that reveals intent would be a great start to gain clarity on the various concerns in this one controller action.

       if current_user.has_permission?('view_candidates')
          if s_key == "All Candidates"
            @candidates = current_user.organization.candidates.all(:is_deleted => false, :is_completed => true)
          elsif s_key == "Candidates Newest -> Oldest"
            @candidates = current_user.organization.candidates.all(:is_deleted => false, :is_completed => true, :order => [:created_at.desc])
          elsif s_key == "Candidates Oldest -> Newest"
            @candidates = current_user.organization.candidates.all(:is_deleted => false, :is_completed => true, :order => [:created_at.asc])
          elsif s_key == "Candidates A -> Z"
            @candidates = current_user.organization.candidates.all(:is_deleted => false, :is_completed => true, :order => [:created_at.asc]).sort! { |a, b| a.last_name <=> b.last_name }
          elsif s_key == "Candidates Z -> A"
            @candidates = current_user.organization.candidates.all(:is_deleted => false, :is_completed => true, :order => [:created_at.asc]).sort! { |a, b| a.last_name <=> b.last_name }.reverse
          end
        else
        ...

The code above is also mostly duplicated in the code below:


        if s_key == "Candidates Newest -> Oldest"
        @candidates = @candidates.sort_by { |c| c.created_at }
        elsif s_key == "Candidates Oldest -> Newest"
        @candidates = @candidates.sort_by { |c| c.created_at }.reverse
        elsif s_key == "Candidates A -> Z"
        @candidates = @candidates.sort_by { |c| c.created_at }.sort! { |a, b| a.last_name <=> b.last_name }
        elsif s_key == "Candidates Z -> A"
        @candidates = @candidates.sort_by { |c| c.created_at }.sort! { |a, b| a.last_name <=> b.last_name }.reverse
        end

This logic would make for an easy extraction into an object to determine the sorting of the candidates. However, there is some unfortunate Law of Demeter violations happening via the current user's organization's assocation with candidates. The use of `all` is troubling, as that represents potentially a very large query, rather than using scopes or where clauses to issue better optimized SQL queries.

This large chunk of logic:

    else
      @job_contacts = JobContact.all(:user_id => current_user.id)
      jobs          = []
      @candidates   = []
      unless @job_contacts.blank?
        @job_contacts.each do |jobs_contacts|
          @job = Job.first(:id => jobs_contacts.job_id, :is_deleted => false)
          jobs << @job
        end
        jobs.each do |job|
         unless job.blank?
          candidate_jobs = CandidateJob.all(:job_id => job.id)
          unless candidate_jobs.blank?
            candidate_jobs.each do |cj|
              candidate = cj.candidate
              if candidate.is_deleted == false && candidate.is_completed == true && candidate.organization_id == current_user.organization_id
                found = false
                unless @candidates.blank?
                  @candidates.each do |cand|
                    if cand.email_address == candidate.email_address
                      found = true
                    end
                  end
                end
                if found == false
                  @candidates << candidate
                end
              end
              if s_key == "Candidates Newest -> Oldest"
                @candidates = @candidates.sort_by { |c| c.created_at }
              elsif s_key == "Candidates Oldest -> Newest"
                @candidates = @candidates.sort_by { |c| c.created_at }.reverse
              elsif s_key == "Candidates A -> Z"
                @candidates = @candidates.sort_by { |c| c.created_at }.sort! { |a, b| a.last_name <=> b.last_name }
              elsif s_key == "Candidates Z -> A"
                @candidates = @candidates.sort_by { |c| c.created_at }.sort! { |a, b| a.last_name <=> b.last_name }.reverse
              end
            end
          end
         end
        end
      end

I think this is extremely hard to follow because of the nested `unless` statements and its size. It's also very difficult to groc intent. Not having any domain knowledge about this application, I cannot easily understand from the code the significance of what it means for a candidate to be deleted, or what it means for a candidate to be found.

To get a hopefully clearer idea of what is happening, I would look at the specs. If there are no specs (and I suspect with code like this that there probably aren't any specs), I would do some browser testing and record results. I would use something like `pry` to capture the `@canditates` variable and use that value as a baseline for establishing verification specs. I would experiment with how to trigger both the `then` and the `else` portions of the main conditional, so that I can establish base lines for both branches. Once I feel confident that I have verification tests in place, I would first extract the chunks of logic I identify as objects into their own methods. Below is an example:

    class SomeController < ApplicationController
        def show_candidates

        @open_jobs = Job.all_open_new(current_user.organization)

        if current_user.has_permission?('view_candidates')
            @candidates = order_for_sort(sort)
        else
            @candidates = find_by_jobs
            if sort == "Candidates Newest -> Oldest"
                @candidates = @candidates.sort_by { |c| c.created_at }
                elsif sort == "Candidates Oldest -> Newest"
                @candidates = @candidates.sort_by { |c| c.created_at }.reverse
                elsif sort == "Candidates A -> Z"
                @candidates = @candidates.sort_by { |c| c.created_at }.sort! { |a, b| a.last_name <=> b.last_name }
                elsif sort == "Candidates Z -> A"
                @candidates = @candidates.sort_by { |c| c.created_at }.sort! { |a, b| a.last_name <=> b.last_name }.reverse
            end
        end
        render :partial => "candidates_list", :locals => { :@candidates => @candidates, :open_jobs => @open_jobs }, :layout => false
    end

    def sort
        params[:sort].blank? ? "All Candidates" : params[:sort]
    end

    def order_for_sort
        case sort
        when "All Candidates"
            current_user.organization.candidates.all(:is_deleted => false, :is_completed => true)
        when "Candidates Newest -> Oldest"
            current_user.organization.candidates.all(:is_deleted => false, :is_completed => true, :order => [:created_at.desc])
        when "Candidates Oldest -> Newest"
            current_user.organization.candidates.all(:is_deleted => false, :is_completed => true, :order => [:created_at.asc])
        when "Candidates A -> Z"
            current_user.organization.candidates.all(:is_deleted => false, :is_completed => true, :order => [:created_at.asc]).sort! { |a, b| a.last_name <=> b.last_name }
        when "Candidates Z -> A"
            current_user.organization.candidates.all(:is_deleted => false, :is_completed => true, :order => [:created_at.asc]).sort! { |a, b| a.last_name <=> b.last_name }.reverse
        end
    end

    def find_by_jobs
        @job_contacts = JobContact.all(:user_id => current_user.id)
        jobs          = []
        @candidates   = []
        unless @job_contacts.blank?
            @job_contacts.each do |jobs_contacts|
                @job = Job.first(:id => jobs_contacts.job_id, :is_deleted => false)
                jobs << @job
            end
            jobs.each do |job|
                unless job.blank?
                candidate_jobs = CandidateJob.all(:job_id => job.id)
                unless candidate_jobs.blank?
                candidate_jobs.each do |cj|
                    candidate = cj.candidate
                    if candidate.is_deleted == false && candidate.is_completed == true && candidate.organization_id == current_user.organization_id
                        found = false
                        unless @candidates.blank?
                            @candidates.each do |cand|
                                if cand.email_address == candidate.email_address
                                found = true
                            end
                        end
                    end
                    if found == false
                        @candidates << candidate
                    end
                end
            end
        end
    end


This is only a start, but what troubles me immediately is that the sorting logic for candidates is different depending on which branch of the main `if / else` conditional we land in. Next I would start to unpack the contents of `find_by_jobs`. I would look for pieces of logic that can be better named, so I can also gain a better understanding of what they are doing. Like this example:

     if candidate.is_deleted == false && candidate.is_completed == true && candidate.organization_id == current_user.organization_id

Based on the name of the action, and the permissions check at the beginning of this action, I think a simple `viewable?` boolean check to encapsulate this logic make sense (from what I understand at the time of writing), like this:

    def viewable?(candidate)
        candidate.is_deleted == false &&
            candidate.is_completed == true &&
                candidate.organization_id == current_user.organization_id &&
                    !@candidates.any? { |cand| cand.email_address == candidate.email_address }
    end

Even though that is pretty gross, it gets us to this:

           jobs.each do |job|
                unless job.blank?
                    candidate_jobs = CandidateJob.all(:job_id => job.id)
                    unless candidate_jobs.blank?
                        candidate_jobs.each do |cj|
                            candidate = cj.candidate
                            if viewable?(candidate)
                                found = false
                            else
                                found = true
                            end
                            if found == false
                                @candidates << candidate
                            end
                        end
                    end
                end
            end

But now this helps expose some unnecessary control flow that can be removed:

           jobs.each do |job|
                unless job.blank?
                    candidate_jobs = CandidateJob.all(:job_id => job.id)
                    unless candidate_jobs.blank?
                        candidate_jobs.each do |cj|
                            candidate = cj.candidate
                            @candidates << candidate if viewable?(candidate)
                        end
                    end
                end
            end


A little more clean up around the unless statements may help too:

           jobs.each do |job|
                if job.present?
                    candidate_jobs = CandidateJob.all(:job_id => job.id)
                    if candidate_jobs.present?
                        candidate_jobs.each do |cj|
                            candidate = cj.candidate
                            @candidates << candidate if viewable?(candidate)
                        end
                    end
                end
            end
        end

Given this amount of reduction, I think there might be a context that can be extracted from here. The input would be a collection of jobs, and the output would be a collection of viewable candidates. Assuming we transfer this logic to a separate context named `JobToCandidates`, we would have something like this:

        jobs.reduce([]) do |candidates, job|
            candidates << JobToCandidates.execute(job, candidates)
            candidates
        end

Considering what we started with, this is certainly a little less difficult to work with, however I would not feel comfortable doing this type of refactor without a a set of verification specs to ensure each step is safely taken without introducing a regression bug. Assuming that my verification specs are green, I would continue on with the other object extraction candidates from earlier in this process, and break them apart into smaller chunks. The main goal for me is to not have code that is pretty, although that is nice, but instead is to have code that is easy to read and understand without needing to spend extra time asking what and why.

