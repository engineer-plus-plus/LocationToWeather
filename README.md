-

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
