package com.svalero.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Favorite {
    private String favoriteId;
    private LocalDateTime regDateTime;
    private String userId;
    private String gameId;
    private Game gameFav;
}