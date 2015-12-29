# crm-authentication-using-swift

Microsoft Dynamics CRM is a very popular CRM Technology. But is has limitations. Direct connections can only be made through .Net technology.
There are some libraries which helps connect to Dynamics CRM through none .Net technologies but all uses ADAL (Active Directory Authentication Library) in which an application should be registered in Azure which can be very difficult.
In Dynamics CRM, there is a SOAP web service endpoint which can also be used to access CRM anywhere. 

# How to use

Copy the CRM Authentication folder into a project in XCODE to get started.

Extend the class or view controller where the result is required with CRMAuthDelegate and add the required methods.

Callback will provide AuthHolder which is consist of four values which are:

1.	Expire time
2.	Key identifier
3.	Token0
4.	Token1

Provide these values to ExecuteSOAP class along with SOAP Body (sample can be found in CRMSOAPBodies) and organization URL. Also extend the desired class with ExecuteSOAPDelegate to get result which will be in pure string and that string will be in XML format.
