module TestStubHelper
  
  def drain_stubs
    stub_request(:post, "https://api.twilio.com/2010-04-01/Accounts/67aa405/Messages.json").
      with(
        body: {"Body"=>"You have successfully updated drain with number 1 to flood prone.", "From"=>"255789454545", "To"=>"0655899266"},
        headers: {
        'Accept'=>'application/json',
        'Accept-Charset'=>'utf-8',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization'=>'Basic NjdhYTQwNTo5YjMxMWMw',
        'Content-Type'=>'application/x-www-form-urlencoded',
        'User-Agent'=>'twilio-ruby/4.13.0 (ruby/x86_64-linux 2.2.3-p173)'
        }).
      to_return(status: 200, body: "", headers: {})

      stub_request(:get, "http://nominatim.openstreetmap.org/search?addressdetails=1&format=json&polygon=0&q=,%20").
      with(  headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Ruby'
        }).
      to_return(status: 200, body: "", headers: {})

       stub_request(:post, "https://api.twilio.com/2010-04-01/Accounts/AC12f20bfa2f6630b53c40266939dab38e/Messages.json").
      with(
        body: {"Body"=>"You have successfully updated drain with number 1 to flood prone.", "From"=>"14256540807", "To"=>"0655899266"},
        headers: {
        'Accept'=>'application/json',
        'Accept-Charset'=>'utf-8',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization'=>'Basic QUMxMmYyMGJmYTJmNjYzMGI1M2M0MDI2NjkzOWRhYjM4ZTpjMmU0ZjEzODM1OGEzMDBmMDcwMzFjNzAyNmM5MzQxZg==',
        'Content-Type'=>'application/x-www-form-urlencoded',
        'User-Agent'=>'twilio-ruby/4.13.0 (ruby/x86_64-linux 2.2.3-p173)'
        }).
      to_return(status: 200, body: "", headers: {})
  end


  def drain_claims_stubs
    stub_request(:get, "http://nominatim.openstreetmap.org/search?addressdetails=1&format=json&polygon=0&q=Sheki%20Road,%20Dar%20es%20salaam").
      with(  headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Ruby'
        }).
      to_return(status: 200, body: "", headers: {})

      stub_request(:post, "https://api.twilio.com/2010-04-01/Accounts/AC12f20bfa2f6630b53c40266939dab38e/Messages.json").
      with(
        body: {"Body"=>"You have been assigned drain with number 1 located at Sheki Road.", "From"=>"14256540807", "To"=>"0765299266"},
        headers: {
        'Accept'=>'application/json',
        'Accept-Charset'=>'utf-8',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization'=>'Basic QUMxMmYyMGJmYTJmNjYzMGI1M2M0MDI2NjkzOWRhYjM4ZTpjMmU0ZjEzODM1OGEzMDBmMDcwMzFjNzAyNmM5MzQxZg==',
        'Content-Type'=>'application/x-www-form-urlencoded',
        'User-Agent'=>'twilio-ruby/4.13.0 (ruby/x86_64-linux 2.2.3-p173)'
        }).
      to_return(status: 200, body: "", headers: {})

  end

end
