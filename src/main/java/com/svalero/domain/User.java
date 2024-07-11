package com.svalero.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class User {
    private String userId;
    private String username;
    private String email;
    private Date birthDate;
    private String password;
    private String role;
}
