package io.github.vtinder.api.security;

import io.jsonwebtoken.Jwts;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jspecify.annotations.NonNull;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import static io.github.vtinder.api.security.JwtAuthConfiguration.JWT_SECRET;

/**
 * Not currently in use. For potential future refactor
 */
@Component
public class SecureEndpointInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             @NonNull HttpServletResponse response,
                             @NonNull Object handler) {
        String jwt = request.getHeader("Authorization");
        String userUUID = Jwts.parser().decryptWith(JWT_SECRET).build()
                .parseSignedClaims(jwt).getPayload().getSubject();
        return true;
    }

}
