# VTinder API

The VTinder API will be used to store centralized data. This includes things like user information, credentials, users'
likes, and matches.

## Quickstart

### Prerequisites:

-   JDK 21
-   An internet connection

### Running the API

- Open your terminal / command line 
- Navigate to the APIs directory.
  - Example: `cd /path/to/VTinder/api`
- Type `./gradlew bootRun`

After following these steps, you should see a splash screen like this:

```
> Task :bootRun

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/

 :: Spring Boot ::                (v4.1.1)

2026-09-27T13:19:03.633-04:00  INFO 28214 --- [api] [           main] io.github.vtinder.api.ApiApplication     : Starting ApiApplication using Java 21.0.11 with PID 28214 (/home/ethanbegley/Desktop/VTinder/api/build/classes/java/main started by ethanbegley in /home/ethanbegley/Desktop/VTinder/api)
2026-09-27T13:19:03.636-04:00  INFO 28214 --- [api] [           main] io.github.vtinder.api.ApiApplication     : No active profile set, falling back to 1 default profile: "default"
2026-09-27T13:19:04.083-04:00  INFO 28214 --- [api] [           main] o.s.boot.tomcat.TomcatWebServer          : Tomcat initialized with port 8080 (http)
2026-09-27T13:19:04.092-04:00  INFO 28214 --- [api] [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2026-09-27T13:19:04.092-04:00  INFO 28214 --- [api] [           main] o.apache.catalina.core.StandardEngine    : Starting Servlet engine: [Apache Tomcat/11.0.24]
2026-09-27T13:19:04.116-04:00  INFO 28214 --- [api] [           main] b.w.c.s.WebApplicationContextInitializer : Root WebApplicationContext: initialization completed in 453 ms
2026-09-27T13:19:04.354-04:00  INFO 28214 --- [api] [           main] o.s.boot.tomcat.TomcatWebServer          : Tomcat started on port 8080 (http) with context path '/'
2026-09-27T13:19:04.357-04:00  INFO 28214 --- [api] [           main] io.github.vtinder.api.ApiApplication     : Started ApiApplication in 1.001 seconds (process running for 1.229)
│████████████···│ 80% EXECUTING [1m 30s]
> :bootRun
```

The server takes requestion on `localhost:8080`. As of this commit, only one endpoint is functional, `/profiles`. You
can quick test this by opening your browser and typing in `localhost:8080/profiles`. This should give you a list of all
profiles stored in the API.

Currently, the database should have mock data (courtesy of Claude) in all the tables. Only the profiles table is 
accessible via HTTP requests for now.
