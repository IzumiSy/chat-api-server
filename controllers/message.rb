
class MessageRoutes < Sinatra::Base
  helpers Sinatra::Param

  post '/api/message' do
    param :room_id, String, required: true
    param :content, String, required: true
    room_id = params[:room_id]
    content = params[:content]
    return if room_id.empty? or content.empty?
    if Room.where(id: room_id).exists?
      message = Message.create(room_id: room_id, content: content)
      body message.to_json
      status 202
    else
      status 404
    end
  end
end
