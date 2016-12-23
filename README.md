[![Build Status](https://api.travis-ci.org/Fivell/worldnet_tps.svg)](https://travis-ci.org/Fivell/worldnet_tps)

# WorldnetTPS

 Ruby API client for World Net TPS gateway, http://worldnettps.com/

## Installation

Add this line to your application's Gemfile:

    gem 'worldnet_tps'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install worldnet_tps

## Usage

### Create gateway object

```ruby
 configuration = {
     currency: 'USD',
     gateway: :worldnet,
     terminal_id: 6003,
     environment: :sandbox,
     shared_secret: 'sandboxUSD'
 }
 
 gateway  =  WorldnetTps::Gateway.new(configuration)
 
```
### Manage secure credit card 

```ruby

card_attributes = {
  card_number: '4000060000000006',
  card_type: 'VISA',
  card_expiry: '1234',
  cvv: '111',
  card_holder_name: 'John Doe',
  merchant_ref: 'worldnet_tps.gem'
}
opearation = gateway.secure_card_registration(card_attributes)

result = operation.update! #or operation.create! for new credit card
```

### Create payment
```ruby

   payment_attributes =  {
       amount: '10.50',
       order_id: 'TXN-124-55',
       post_code: '98104',
       email: 'john.doe@gmail.com',
       address1: '100 MAIN ST',
       address2: 'SEATTLE WA',
       phone: '2064960114',
       city: 'SEATTLE',
       country: 'US'
       card_number: '4000060000000006',
       card_type: 'VISA',
       card_expiry: '1223',
       card_holder_name: 'John Doe',
       cvv: '111',
       order_id: 'TXN-124-59'
   }
   
    
   # using secure card is also supported
   # to do this card_reference attribute from secure_card_registration 
   # operation result should be used
   # isntead of real card_number and card_type
   payment_attributes = {
    #...
      card_number: '2967539270368883',
      card_type: WorldnetTps::Const::SECURECARD
    #...
   } 
   
   operation =  gateway.payment(payment_attributes)
   result = operation.invoke!
       
```


### Check [specs](https://github.com/Fivell/worldnet_tps/tree/master/spec/) for more operations
   
     
### Access to raw request/response
```ruby
operation.response.body
#=> "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<SECURECARDUPDATERESPONSE><MERCHANTREF>worldnet_tps.gem</MERCHANTREF><CARDREFERENCE>2967539209767734</CARDREFERENCE><DATETIME>15-12-2016:15:03:56:521</DATETIME><HASH>70d9929284120c01075eb19e9e1e9fcc</HASH></SECURECARDUPDATERESPONSE>"

operation.request.body
#=> "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<SECURECARDUPDATE>\n  <MERCHANTREF>worldnet_tps.gem</MERCHANTREF>\n  <TERMINALID>6003</TERMINALID>\n  <DATETIME>10-12-2016:12:00:00:000</DATETIME>\n  <CARDNUMBER>5001650000000000</CARDNUMBER>\n  <CARDEXPIRY>1234</CARDEXPIRY>\n  <CARDTYPE>MASTERCARD</CARDTYPE>\n  <CARDHOLDERNAME>John Doe</CARDHOLDERNAME>\n  <HASH>92b659e02301af239ec925373f9c3bb7</HASH>\n  <CVV>111</CVV>\n</SECURECARDUPDATE>\n"
```

## Worldnet TPS Documentation

  https://docs.worldnettps.com/doku.php?id=developer:integrator_guide

TODO: 
 - XML Requests with eDCC
 - Dynamic Descriptors 
 - Pre-Authorisation 
 - Unreferenced Refunds

## Contributing



1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
