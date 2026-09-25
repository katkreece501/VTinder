package io.github.vtinder.api.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Profile {

    private int id;
    private String name;
    private String year;
    private String bio;
    private String major;
    private String interests;
    private String gradDate;
    private String nextSteps;
    private int age;
    private int heightInches;
    private String gender;
    private byte[] image;

}
