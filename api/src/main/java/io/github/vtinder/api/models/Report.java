package io.github.vtinder.api.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Report {

    private long id;
    private String reporter;
    private String reported;
    private Instant timestamp;
    private String reason;

}
