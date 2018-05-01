require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include RoadMap

  base_uri 'https://www.bloc.io/api/v1'
 
  def initialize(email, password)
    response = self.class.post('/sessions', body: { email: email, password: password })
    raise 'Invalid email or password' if response.code == 404
    @auth_token = response["auth_token"]
  end 

  def get_me
    response = self.class.get('/users/me', headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end 

  def get_mentor_availability(mentor_id)
    response = self.class.get('/mentors/#{mentor_id}/student_availability', headers: {'authorization' => @auth_token})
    JSON.parse(response.body)
  end 

  def get_messages(page = 0)
    if page > 0
      message_url = '/message_threads?page=#{page}'
    else 
      message_url = '/message_threads'
    end 
    response = self.class.get(message_url, headers: {'authorization' => @auth_token})
    JSON.parse(response.body)
  end 

  def create_message(sender, recipient_id, token = nil, subject, stripped_text)
    response = self.class.post("/messages", headers: { "authorization" => @user_auth_token }, body: {
      sender: sender,
      recipient_id: recipient_id,
      token: token,
      subject: subject,
      stripped_text: stripped_text
      })
  end

end 