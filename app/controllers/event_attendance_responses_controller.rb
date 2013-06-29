class EventAttendanceResponsesController < ApplicationController

  # PUT /event_attendance_responses/1
  def update
    @event_attendance_response = EventAttendanceResponse.find(params[:id])

    if @event_attendance_response.update_attributes(params[:event_attendance_response])
      flash[:notice] = 'RSVP Saved.'
    else
      flash[:error]  = 'Unable to save RSVP.'
    end
    
    redirect_to [@event_attendance_response.project_event.project, @event_attendance_response.project_event]
  end

end
