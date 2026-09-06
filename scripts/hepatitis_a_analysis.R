# ============================================================
# PANEL DATA SVI ANALYSIS (128 ROWS)
# ============================================================

# Load required package
install.packages("lme4")  # Only need to run this once
library(lme4)

# Read your data
panel_data <- read.csv("Maine_panel.csv")

# Check the data
head(panel_data)
nrow(panel_data)  # Should be 128

# Run mixed-effects Poisson model
# County = random intercept
# SVI = fixed effect
# offset(log(Population)) = adjusts for different county sizes
model <- glmer(Count ~ SVI + (1 | County) + offset(log(Population)), 
               data = panel_data, 
               family = poisson,
               control = glmerControl(optimizer = "bobyqa"))

# View results
summary(model)

# Calculate IRR and p-value
irr <- exp(fixef(model)["SVI"])
p_val <- summary(model)$coefficients["SVI", "Pr(>|z|)"]

cat("\n========================================\n")
cat("PANEL DATA SVI RESULTS\n")
cat("========================================\n")
cat("IRR =", round(irr, 3), "\n")
cat("p-value =", round(p_val, 4), "\n")

if(p_val < 0.05) {
  cat("✅ STATISTICALLY SIGNIFICANT!\n")
} else {
  cat("❌ Not significant\n")
}

# Read the cleaned file
panel_data <- read.csv("Maine_panel.csv", stringsAsFactors = FALSE)

# Check if it worked
head(panel_data)
nrow(panel_data)

lines <- readLines("Maine_panel.csv")
lines[1:3]

# Read the file but SKIP the first row (the broken header)
panel_data <- read.csv("Maine_panel.csv", 
                       skip = 1,
                       header = FALSE,
                       stringsAsFactors = FALSE)

# Add clean column names
colnames(panel_data) <- c("County", "Year", "Count", "Rate", "SVI", "Population")

# Check the result
head(panel_data)

# Step 3a: Read the raw file
raw_lines <- readLines("Maine_panel.csv")

# Step 3b: Remove the hidden character from the header
raw_lines[1] <- gsub("\xa0", "", raw_lines[1])

# Step 3c: Write a clean file
writeLines(raw_lines, "Maine_panel_clean.csv")

# Step 3d: Now import the clean file
panel_data <- read.csv("Maine_panel_clean.csv", stringsAsFactors = FALSE)

# Step 3e: Check it
head(panel_data)
nrow(panel_data)



# Step 3a: Read the file as raw bytes
raw_bytes <- readBin("Maine_panel.csv", "raw", file.info("Maine_panel.csv")$size)

# Step 3b: Convert raw bytes to characters (handles the bad encoding)
raw_text <- rawToChar(raw_bytes[raw_bytes != 0])

# Step 3c: Split into lines
lines <- strsplit(raw_text, "\n")[[1]]

# Step 3d: Fix the header (remove the hidden character)
lines[1] <- gsub("[^A-Za-z,0-9]", "", lines[1])  # Keep only letters, numbers, and commas

# Step 3e: Write a clean file
writeLines(lines, "Maine_panel_clean.csv")

# Step 3f: Import the clean file
panel_data <- read.csv("Maine_panel_clean.csv", stringsAsFactors = FALSE)

# Step 3g: Check the result
head(panel_data)
nrow(panel_data)

# Check the data
head(Maine_panel)

# Check the number of rows
nrow(Maine_panel)

# Check column names
colnames(Maine_panel)


# Fix SVI and Population for all counties
# Create a lookup table with correct values
lookup <- data.frame(
  County = c("ANDROSCOGGIN", "AROOSTOOK", "CUMBERLAND", "FRANKLIN", 
             "HANCOCK", "KENNEBEC", "KNOX", "LINCOLN", "OXFORD", 
             "PENOBSCOT", "PISCATAQUIS", "SAGADAHOC", "SOMERSET", 
             "WALDO", "WASHINGTON", "YORK"),
  SVI_correct = c(0.9333, 0.8667, 0.2667, 0.6000, 0.1333, 0.5333, 
                  0.0000, 0.2000, 0.4667, 0.7333, 0.8000, 0.0667, 
                  0.6667, 0.4000, 1.0000, 0.3333),
  Population_correct = c(107958, 67431, 294520, 29933, 54832, 122158, 
                         39809, 34415, 57741, 151696, 16864, 35720, 
                         50573, 39723, 31378, 206074)
)

# Merge the correct values into your data
Maine_panel <- Maine_panel %>%
  select(-SVI, -Population) %>%  # Remove the old NA columns
  left_join(lookup, by = "County")  # Add the correct ones

# Check the result
head(Maine_panel)



# Step 8a: Create lookup vectors for SVI and Population
county_names <- c("ANDROSCOGGIN", "AROOSTOOK", "CUMBERLAND", "FRANKLIN", 
                  "HANCOCK", "KENNEBEC", "KNOX", "LINCOLN", "OXFORD", 
                  "PENOBSCOT", "PISCATAQUIS", "SAGADAHOC", "SOMERSET", 
                  "WALDO", "WASHINGTON", "YORK")

svi_values <- c(0.9333, 0.8667, 0.2667, 0.6000, 0.1333, 0.5333, 
                0.0000, 0.2000, 0.4667, 0.7333, 0.8000, 0.0667, 
                0.6667, 0.4000, 1.0000, 0.3333)

pop_values <- c(107958, 67431, 294520, 29933, 54832, 122158, 
                39809, 34415, 57741, 151696, 16864, 35720, 
                50573, 39723, 31378, 206074)

# Step 8b: Fix the SVI column
Maine_panel$SVI <- svi_values[match(Maine_panel$County, county_names)]

# Step 8c: Fix the Population column
Maine_panel$Population <- pop_values[match(Maine_panel$County, county_names)]

# Step 8d: Check the result
head(Maine_panel)

# Step 8e: Check for any remaining NAs
sum(is.na(Maine_panel$SVI))  # Should be 0
sum(is.na(Maine_panel$Population))  # Should be 0

# Check the first 20 rows
head(Maine_panel, 20)

# Check the total number of rows
nrow(Maine_panel)

# Check if SVI and Population have any NA values
sum(is.na(Maine_panel$SVI))
sum(is.na(Maine_panel$Population))

# Step 1: Clean the County column to remove hidden characters
Maine_panel$County <- gsub("[^A-Z]", "", Maine_panel$County)

# Step 2: Convert to uppercase
Maine_panel$County <- toupper(Maine_panel$County)

# Step 3: Remove any trailing spaces
Maine_panel$County <- trimws(Maine_panel$County)

# Step 4: Check the unique county names
unique(Maine_panel$County)

# Step 2a: Create lookup vectors
county_names <- c("ANDROSCOGGIN", "AROOSTOOK", "CUMBERLAND", "FRANKLIN", 
                  "HANCOCK", "KENNEBEC", "KNOX", "LINCOLN", "OXFORD", 
                  "PENOBSCOT", "PISCATAQUIS", "SAGADAHOC", "SOMERSET", 
                  "WALDO", "WASHINGTON", "YORK")

svi_values <- c(0.9333, 0.8667, 0.2667, 0.6000, 0.1333, 0.5333, 
                0.0000, 0.2000, 0.4667, 0.7333, 0.8000, 0.0667, 
                0.6667, 0.4000, 1.0000, 0.3333)

pop_values <- c(107958, 67431, 294520, 29933, 54832, 122158, 
                39809, 34415, 57741, 151696, 16864, 35720, 
                50573, 39723, 31378, 206074)

# Step 2b: Fix SVI and Population
Maine_panel$SVI <- svi_values[match(Maine_panel$County, county_names)]
Maine_panel$Population <- pop_values[match(Maine_panel$County, county_names)]

# Step 2c: Check the result
head(Maine_panel, 20)

library(lme4)

model <- glmer(Count ~ SVI + (1 | County) + offset(log(Population)), 
               data = Maine_panel, 
               family = poisson,
               control = glmerControl(optimizer = "bobyqa"))


names(Maine_panel)
names(Maine_panel)[3] <- "Count"

names(Maine_panel)
model <- glmer(Count ~ SVI + (1 | County) + offset(log(Population)), 
               data = Maine_panel, 
               family = poisson,
               control = glmerControl(optimizer = "bobyqa"))


summary(model)

# Calculate IRR
irr <- exp(fixef(model)["SVI"])

# Get p-value
p_val <- summary(model)$coefficients["SVI", "Pr(>|z|)"]

cat("========================================\n")
cat("PANEL DATA SVI RESULTS (128 ROWS)\n")
cat("========================================\n")
cat("IRR =", round(irr, 3), "\n")
cat("p-value =", round(p_val, 4), "\n")

if(p_val < 0.05) {
  cat("✅ STATISTICALLY SIGNIFICANT!\n")
} else {
  cat("❌ Not significant\n")
}
irr <- exp(fixef(model)["SVI"])
ci <- exp(confint(model, method = "Wald")["SVI", ])

cat("IRR =", round(irr, 3), "\n")
cat("95% CI:", round(ci[1], 3), "-", round(ci[2], 3), "\n")


# Severity Analysis
severity <- data.frame(
  Year = 2019:2023,
  Deaths = c(225, 179, 135, 118, 85),
  Cases = c(18846, 9952, 5728, 2265, 1648)
)

severity$Deaths_per_1000 <- (severity$Deaths / severity$Cases) * 1000

print(severity)

# Create the plot
library(ggplot2)
p_sev <- ggplot(severity, aes(x = Year, y = Deaths_per_1000)) +
  geom_line(color = "darkred", size = 1.5) +
  geom_point(size = 4, color = "darkred") +
  labs(
    title = "Hepatitis A Severity: Deaths per 1,000 Cases",
    subtitle = "United States, 2019-2023",
    x = "Year",
    y = "Deaths per 1,000 Cases"
  ) +
  theme_minimal(base_size = 14)

print(p_sev)

install.packages("spdep")
install.packages("sf")
install.packages("tigris")
install.packages("dplyr")

library(sf)
library(tigris)
library(spdep)
library(dplyr)

# Download Maine county shapefile (takes a few seconds)
maine_map <- counties(state = "ME", class = "sf", year = 2020)

# Calculate rate per county (total cases / total population * 100000)
county_rates <- Maine_panel %>%
  group_by(County) %>%
  summarise(
    Total_Cases = sum(Count),
    Total_Pop = sum(Population),
    Rate = (Total_Cases / Total_Pop) * 100000
  )

# View the rates
print(county_rates)

# Clean county names in the shapefile to match your data
maine_map$NAME <- toupper(maine_map$NAME)

# Merge the shapefile with your rate data
maine_map_data <- maine_map %>%
  left_join(county_rates, by = c("NAME" = "County"))

# Check the merge
head(maine_map_data)

# Create neighbor list (counties that touch each other)
nb <- poly2nb(maine_map_data, queen = TRUE)

# Create weights
lw <- nb2listw(nb, style = "W")

# Run Getis-Ord Gi*
gi_star <- localG(maine_map_data$Rate, lw)

# Add results to the map
maine_map_data$GiZScore <- as.numeric(gi_star)
maine_map_data$GiPValue <- 2 * (1 - pnorm(abs(maine_map_data$GiZScore)))

# Classify into bins
maine_map_data <- maine_map_data %>%
  mutate(
    Gi_Bin = case_when(
      GiZScore > 2.58 & GiPValue < 0.01 ~ 3,   
      GiZScore > 1.96 & GiPValue < 0.05 ~ 2,   
      GiZScore > 1.65 & GiPValue < 0.10 ~ 1,   
      GiZScore < -2.58 & GiPValue < 0.01 ~ -3, 
      GiZScore < -1.96 & GiPValue < 0.05 ~ -2, 
      GiZScore < -1.65 & GiPValue < 0.10 ~ -1, 
      TRUE ~ 0                                 
    )
  )

# Load ggplot2 if not already loaded
library(ggplot2)

# Create the hotspot map
hotspot_map <- ggplot(maine_map_data) +
  geom_sf(aes(fill = factor(Gi_Bin)), color = "white", size = 0.3) +
  scale_fill_manual(
    values = c(
      "3" = "darkred",
      "2" = "red",
      "1" = "pink",
      "0" = "lightgray",
      "-1" = "lightblue",
      "-2" = "blue",
      "-3" = "darkblue"
    ),
    name = "Hot Spot Confidence",
    labels = c(
      "3" = "99% Hot",
      "2" = "95% Hot",
      "1" = "90% Hot",
      "0" = "Not Significant",
      "-1" = "90% Cold",
      "-2" = "95% Cold",
      "-3" = "99% Cold"
    )
  ) +
  labs(
    title = "Hepatitis A Hot Spots (Getis-Ord Gi*)",
    subtitle = "Maine Counties, 2016-2023",
    caption = "Red = High rates surrounded by high rates (Hot Spot)\nBlue = Low rates surrounded by low rates (Cold Spot)"
  ) +
  theme_void() +
  theme(
    legend.position = "right",
    plot.title = element_text(size = 16, face = "bold"),
    plot.subtitle = element_text(size = 12),
    plot.caption = element_text(size = 8, hjust = 0)
  )

# Show the map
print(hotspot_map)


# Show only counties with significant hot/cold spots
significant <- maine_map_data %>%
  filter(Gi_Bin != 0) %>%
  select(NAME, Rate, GiZScore, GiPValue, Gi_Bin) %>%
  arrange(desc(Gi_Bin))

print(significant)



# Better Hotspot Map with Clear Colors
library(ggplot2)

hotspot_map_v2 <- ggplot(maine_map_data) +
  geom_sf(aes(fill = factor(Gi_Bin)), color = "black", size = 0.4) +
  scale_fill_manual(
    values = c(
      "3" = "#B30000",  # Dark Red (99% Hot)
      "2" = "#E60000",  # Red (95% Hot)
      "1" = "#FF9999",  # Light Red (90% Hot)
      "0" = "#F0F0F0",  # Light Gray (Not Significant)
      "-1" = "#99CCFF", # Light Blue (90% Cold)
      "-2" = "#0066CC", # Blue (95% Cold)
      "-3" = "#003366"  # Dark Blue (99% Cold)
    ),
    name = "Hot Spot Confidence",
    labels = c(
      "3" = "99% Hot Spot",
      "2" = "95% Hot Spot",
      "1" = "90% Hot Spot",
      "0" = "Not Significant",
      "-1" = "90% Cold Spot",
      "-2" = "95% Cold Spot",
      "-3" = "99% Cold Spot"
    ),
    drop = FALSE
  ) +
  geom_sf_text(aes(label = NAME), size = 2.5, color = "black", check_overlap = TRUE) +
  labs(
    title = "Hepatitis A Hot Spots (Getis-Ord Gi*)",
    subtitle = "Maine Counties, 2016-2023",
    caption = "Red = High rates surrounded by high rates (Hot Spot)\nBlue = Low rates surrounded by low rates (Cold Spot)"
  ) +
  theme_void() +
  theme(
    legend.position = "right",
    plot.title = element_text(size = 16, face = "bold"),
    plot.subtitle = element_text(size = 12),
    plot.caption = element_text(size = 8, hjust = 0),
    legend.text = element_text(size = 10)
  )

# Show the map
print(hotspot_map_v2)

# Save with high resolution
ggsave("hotspot_map_publication.png", hotspot_map_v2, width = 10, height = 8, dpi = 300)


# Create a clean table of significant counties
significant <- maine_map_data %>%
  filter(Gi_Bin != 0) %>%
  select(NAME, Rate, GiZScore, GiPValue, Gi_Bin) %>%
  arrange(desc(Gi_Bin))

# Add interpretation labels
significant$Interpretation <- case_when(
  significant$Gi_Bin == 3 ~ "99% Hot Spot",
  significant$Gi_Bin == 2 ~ "95% Hot Spot",
  significant$Gi_Bin == 1 ~ "90% Hot Spot",
  significant$Gi_Bin == -1 ~ "90% Cold Spot",
  significant$Gi_Bin == -2 ~ "95% Cold Spot",
  significant$Gi_Bin == -3 ~ "99% Cold Spot",
  TRUE ~ "Not Significant"
)

print(significant)
