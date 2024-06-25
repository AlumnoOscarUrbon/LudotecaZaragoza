package com.svalero.domain;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Boardgame {
    private String boardgameId;
    private String name;
    private String brandId;
    private String description;
    private Date date;
    private String picture;
}
