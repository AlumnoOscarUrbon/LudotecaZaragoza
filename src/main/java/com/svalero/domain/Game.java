package com.svalero.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Game {
    private String gameId;
    private String name;
    private String gameCategoryId;
    private String description;
    private LocalDateTime releaseDateTime;
    private String picture;
    private GameCategory gameCategory;
}
