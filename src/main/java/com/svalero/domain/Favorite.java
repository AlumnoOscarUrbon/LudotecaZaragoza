package com.svalero.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Favorite {
    private String favoriteId;
    private Date regDate;
    private String userId;
    private String gameId;
}