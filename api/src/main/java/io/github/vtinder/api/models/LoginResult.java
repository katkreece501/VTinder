package io.github.vtinder.api.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginResult {

    private String uuid;
    // Boxed so Jackson names the field "isModerator" rather than "moderator"
    private Boolean isModerator;

}
