class EventController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:save]
  URL = 'https://calendly.com/api/v1/hooks'
  HEADERS = { 'x-token': API_KEY}

  # Load the page and start the subscription (assume only 1 subscription)
  # load a view that gives a frame & some sort of no updates view
  def index
    # TODO pull out api key before pushing to github & pull out binding prys
    res = HTTParty.get URL, headers: HEADERS
    message = JSON.parse res.body, symbolize_names: true
    if res.code == 200
      numSubs = message[:data].count
      if numSubs > 0
        subId = message[:data][0][:id]
      else
        # Port is open in our router
        params = { url: SUBSCRIPTION_URL, events: ['invitee.created', 'invitee.canceled'] }
        newRes = HTTParty.post URL, body: params, headers: HEADERS
        message = JSON.parse newRes.body, symbolize_names: true
        # TODO need error handling
        subId = message[:id]
      end
    end
  end

  # Endpoint to save event updates
  def save
    event = params
    # This assumes that all keys exists. Yay no error handling...
    toSave = Event.new(update_type: event[:event],
      start_time: event[:payload][:event][:start_time_pretty],
      end_time: event[:payload][:event][:end_time_pretty],
      location: event[:payload][:event][:location],
      invitee_name: event[:payload][:invitee][:name],
      duration: event[:payload][:event_type][:duration],
      event_kind: event[:payload][:event_type][:kind])
    toSave.save
    render json: {}, status: 200
  end

  # Endpoint to load latest event updates
  def load
    if params[:lastId].to_i > 0
      @events = Event.where("id > ? ", params[:lastId].to_i).order({ id: 'desc'})
      # There is no limit on this so technically
      # if a large amount of events came in, this would fail.
    else
      # returns nil if no records
      @events = Event.order({ id: 'desc'}).last(10)
    #render a view that can add on to the current home page.
    end
    render layout: false
  end

  # Endpoint to hit manually to delete borked subscriptions
  # Mainly to clear out subscriptions as I am testing the app.
  def delete
    res = HTTParty.get URL, headers: HEADERS
    message = JSON.parse res.body, symbolize_names: true
    if res.code == 200
      numSubs = message[:data].count
      if numSubs > 0
        message[:data].each do |sub|
          id = sub[:id]
          delRes = HTTParty.delete "#{URL}/#{id}", headers: HEADERS
          #TODO handle status codes
        end
      end
    end
  end
end
