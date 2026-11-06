package io.github.vtinder.api.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Message {

    private long id;
    private String senderUUID;
    private String receiverUUID;
    private Instant timestamp;
    private String message;
    private boolean fromMe;

}
