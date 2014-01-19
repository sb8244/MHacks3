class EvernoteController < ApplicationController

  def test
    client = EvernoteOAuth::Client.new(
      token: current_user.evernote_token
    )
    note_store = client.note_store
 
    # Make API calls
    @notebooks = note_store.listNotebooks
  end

end