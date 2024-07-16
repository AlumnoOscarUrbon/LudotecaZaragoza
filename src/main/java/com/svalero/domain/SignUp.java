package com.svalero.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class SignUp {
    private String signUpId;
    private LocalDateTime regDateTime;
    private String userId;
    private String activityId;
    private Activity activityFav;

}