package io.github.vtinder.api.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {

    private String uuid;
    private String name;
    private String email;
    private Boolean isModerator;

}
