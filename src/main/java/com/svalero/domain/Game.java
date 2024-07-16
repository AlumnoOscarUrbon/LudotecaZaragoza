package com.svalero.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Game {
    private String gameId;
    private String name;
    private String gameCategoryId;
    private String description;
    private Date releaseDate;
    private String picture;
    private GameCategory gameCategory;
}
