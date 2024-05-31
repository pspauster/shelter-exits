# NYC Shelter Exits

New York City is facing a historic homelessness crisis. But getting data on how many people are using NYC shelters is complicated. This repository, built in collaboration with City Limits News, seeks to liberate data on exits from NYC Shelters, as required by Local Law 79 of 2022.

It's an extension of work on the [NYC Shelter Count](https://github.com/anesta95/nyc_shelter_count). You can view the full project tracker and read more at [City Limits](https://citylimits.org/nyc-shelter-count/).

The repository creates a data file categorizing all the exits from NYC homeless shelters from the [PDFs](https://www.nyc.gov/assets/operations/downloads/pdf/temporary_housing_report.pdf) that are posted monthly on the Department of Homeless Services Webpage, but overwritten each month. This repository automatically updates the dataset each month when a new report comes out.

## Use this data

The `shelter_exits.csv` file in the `data` folder is cleaned and tidy version of the [exit tables from monthly temporary housing reports](https://www.nyc.gov/assets/operations/downloads/pdf/temporary_housing_report.pdf) released by the NYC Department of Homeless Services.

This data is available for public use with attribution. You can cite Patrick Spauster for City Limits

## Notes and limitations

Agencies suppress exact numbers of exits for categories where the total number of exits in the month was less than 10. As part of data cleaning, this repository replaces exit categories with <10 as 0, which may result in slight undercounts in some categories and upon aggregation. A version without the replacement is available at `data/shelter_exits_raw.csv`

Exits from DHS shelter are 'reconciled' each month. That means that if a person exits shelter, but returns to shelter within a given time window, that exit is not a true "exit" and will not appear here. As a result, the DHS exit data is for any given report month is actually for a different exit month, which this data cleaning pipeline corrects for. The reconciliation period is different for different DHS subpopulations: 1 month for DHS families with children and adult families and 2 months for DHS single adults. Exits for other agencies do not have reconciliation periods. For more information see the footnotes in the temporary housing report pdfs. Exits from DHS shelters also exclude exits from people in specialized programs like Safe Havens and Stabilization Beds.

The `field_categorization` spreadsheets are user manual categorizations of exit types as of May 2024, according to reporting on exit categories from DHS. Exits to "permanent housing" can be both subsidized or unsubsidized, according to DHS, but include things like exiting to housing with a rental subsidy or moving in with family.

Exit type categorizations for non-DHS agencies have not been vetted with agencies. These category fields are provided for simplicity of analysis, but they can also be changed for different reporting or research purposes.

## Data Dictionary

**DHS unhoused report**
| Variable    | Type | Description |
| -------- | ------- | ------- |
| facility_or_program_type  | character    | The exit type as listed in the pdf report |
| agency | character   | The agency managing the shelter where each exit came from |
| report_date    | character   | The date of the report on the pdf in MM_YYYY format |
| date  | date   | The date of the exit, accounting for delays in reporting by subpopulation |
| series  | character   | The subpopulation for the exit count, either `families_with_children`, `adult_families`, `runaway_and_homeless_youth`, or `total_single_adults` |
| exits  | number   | The number of exits for that agency, subpopulation, and exit type in that month |
| category  | character   | A user-created aggregate category based on exit type descriptions, created by coder |
| housing_category  | character   | A user-create field whether this exit would be categorized as an exit to permanent housing or not, per DHS sourcing |

## Analysis
The data in the analysis file supplies the data for the feature story, ['Exit Unknown: Where do people Go After They Exit NYC Homeless Shelters'](https://citylimits.org/2024/05/14/exit-unknown-where-do-people-go-after-leaving-nyc-homeless-shelters/) for City Limits, published May 2024.
- Data on the monthly exits from DHS shelters comes from the DHS daily report PDFs posted to the city's website. This data excludes adults in specialized programs
- Data on entrants to shelter and monthly shelter populations comes from the Local Law 79 (current) temporary housing assistance usage reports published on NYC's open data portal
Note: data in this story is for DHS shelters ONLY.

This repository is created and maintained by Patrick Spauster. With questions or corrections you can reach them at patrick.spauster@gmail.com

Updated May 2024
