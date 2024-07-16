package com.svalero.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;
import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Activity {
    private String activityId;
    private String name;
    private String activityCategoryId;
    private String description;
    private LocalDateTime activityDateTime;
    private String picture;
    private ActivityCategory activityCategory;
}
