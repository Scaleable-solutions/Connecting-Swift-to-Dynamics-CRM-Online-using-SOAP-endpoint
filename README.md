# Connecting iOS(iPhone/iPad) to Dynamics CRM Online using SOAP endpoint


Non .Net clients can access Microsoft Dynamics CRM business data using SOAP end point or Web API. In this tutorial we will learn how to perform SOAP authentication to Microsoft Dynamics CRM from Swift. We have made a sample application which sends WhoAmIRequest and CRM responds back with the logged in name.

---------

#Working

##Service Handler

First of all we have made a custom Service Handler class which handles the network requests. It requires NSMutableURLRequest object.

##AuthXMLParser

This is the specialized XML parser for CRM authentication response. It parses the response returned from CRM authentication.

##AuthHolder

This is simply a container class which holds the return values for authentication.

```swift
class AuthHolder : NSObject {

var keyIdentifier:String = ""
var token0:String = ""
var token1:String = ""
var expire:String = ""
}
```

##CRMAuth

This is the main class which does all the authentication process. We are passing the domain URL, username and password and it return four values after making a network call and parsing.

Those 4 values are:

1.	Expire time
2.	Key identifier
3.	Token0
4.	Token1

1st one is to determine when the authentication token will expire and 2nd, 3rd and 4th is being used for making SOAP Header

##ExecuteSOAP

This class create and execute SOAP Request with the help of **tokens** and **keyidentifier** returned by **CRMAuth** class.

##CRMSOAPBodies

This class holds the SOAP bodies which is used in SOAP request inside SOAP Envelope as it contains the query that do some action(Create, Update, Delete and Retrieve etc.).

---------

#Conclusion

The given sample is great starter app to perform authentication in iOS apps. It gives a good overview of how you can make connection with CRM in external apps not developed in .NET. You can freely use this sample in your apps for authentication purposes.






