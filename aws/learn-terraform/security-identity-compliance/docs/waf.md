# AWS Web Application Firewall

Protects web applications from common web exploits that could affect application availability, compromise security, or consume excessive resources.

Works at Layer 7 (HTTP/HTTPS) and can inspect traffic based on any attribute of the HTTP request.

Can be deployed on:
- Application Load Balancer
- CloudFront
- API Gateway


## WAF Conditions, Rules, and Web ACLs

Conditions define the basic characteristics that you want WAF to watch for in the web request

Rule Types:
- Regular rules - use only conditions to target specific requests
- Rate-based rules - count occurrences of events and block requests if they exceed a threshold

Web ACLs are containers for rules and rule groups
- Used to define actions for each rule - allow, block, or count


Define Web ACL (Web Access Control List) Rules:
- IP Set: up to 10,000 ip addresses
- HTTP headers, body, or URI strings
- Size constraints, geo-match (block countries)
- Rate-based rules (to count occurences of events) - for DDoS protection

Web ACL are Regional except for CloudFront

## WAF - Fixed IP while using WAF with a Load Balancer
- WAF does not support the Network Load Balancer (Layer 4)
- We can use Global Accelerator to have a fixed IP address for our WAF
- Then we can attach WAF to the Application load balancer in the same region

## References
https://tutorialsdojo.com/aws-waf/

https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-rate-based.html

https://aws.amazon.com/waf/faqs/