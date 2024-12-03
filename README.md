# README

This application demonstrates the requested functionality, but there are a few improvements I would make in a production setting that are omitted here due to time constraints:

- **Use Redis for Caching**
  Cache should be handled by Redis instead of SQLite. Redis can automatically manage the 30-minute expiration time and offers other performance and scalability benefits. I initially attempted to implement Redis but switched to SQLite (Plan B) due to integration delays.
- **Cron Job for Expired Cache Entries**
  With Plan B, the management of expired cache entries falls on us. A cron job should be implemented to remove stale entries. Let me emphasize that, for production, I would make the Redis solution work.
- **Environment-Specific Configuration**
  Values like the cache expiration time and the weather service API key should be stored in environment variables (e.g., `.env` file or a secrets manager). This ensures sensitive data isn’t hard-coded and makes configuration more flexible.
- **Environment-Specific Settings**
  The app currently uses the same configuration for all environments. For production readiness, different configurations should be defined for development, testing, production, and any other environments used.
- **Code Comments and API Documentation**
  I aim for my code to be self-explanatory for anyone familiar with Rails. I avoid comments that merely restate the obvious or duplicate knowledge already available in the Rails documentation. However, I would include comments for non-obvious logic or areas not covered by Rails documentation. Additionally, the app should include API documentation (e.g., Swagger or OpenAPI specs) to simplify integration with other teams.
- **Scalability and Asynchronous Requests**
  This implementation assumes that downstream services can handle the traffic from this service synchronously. In production, that may not be the case. I would make requests to downstream services asynchronous, possibly using message queues like RabbitMQ, depending on the requirements and trade-offs. This would ensure that the app can scale gracefully under higher loads.
- **Trust Assumptions and Security**
  This service trusts its users and downstream services. It assumes users won’t input sensitive data (e.g., nuclear secrets or PII) into the address field to be sent to third parties. Likewise, it assumes downstream services won’t send back malicious or inappropriate data. In production, these assumptions must be validated or mitigated. Input validation, sanitization, and monitoring are essential to ensure security and avoid vulnerabilities like SQL injection or XSS.
- **Error Handling for Downstream Services**
  This service assumes downstream services are always available and reliable. In production, these scenarios must be handled carefully, with retries, dead-letter queues, and fallback mechanisms.
- **Testing Coverage**
  Ensure comprehensive unit and integration tests exist for all critical functionalities, including edge cases.



## Requirements:

• Must be done in Ruby on Rails
• Accept an address as input
• Retrieve forecast data for the given address. This should include, at minimum, the current temperature (Bonus points - Retrieve high/low and/or extended forecast)
• Display the requested forecast details to the user
• Cache the forecast details for 30 minutes for all subsequent requests by zip codes. Display indicator if result is pulled from cache.
Assumptions:
• This project is open to interpretation
• Functionality is a priority over form
• If you get stuck, complete as much as you can
Submission:
• Use a public source code repository (GitHub, etc) to store your code
• Send us the link to your completed code

The [company Coding Assessment Exercise is attached.  Please return as a single GitHub Link with the Code, ReadMe file, and Unit Tests in it.
Please remember – it’s not just whether or not the code works that they will be focused on seeing – it’s all the rest of what goes into good Senior Software Engineering daily practices for Enterprise Production Level Code – such as specifically:
• Unit Tests (#1 on the list of things people forget to include – so please remember, treat this as if it were true production level code, do not treat it just as an exercise),
• Detailed Comments/Documentation within the code, also have a README file
• Include \*Decomposition\* of the Objects in the Documentation
• Design Patterns (if/where applicable)
• Scalability Considerations (if applicable)
• Naming Conventions (name things as you would name them in enterprise-scale production code environments)
• Encapsulation, (don’t have 1 Method doing 55 things)
• Code Re-Use, (don’t over-engineer the solution, but don’t under-engineer it either)
• and any other industry Best Practices.
Using ChatGPT, Copilot, or any other AI tools to complete the assignment or to use during your interview is not allowed.
