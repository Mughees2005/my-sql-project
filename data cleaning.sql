select * from layoffs;

-- 1. Remove duplicates
-- 2. standardize the data
-- 3. null values 
-- 4. remove any columns 

CREATE TABLE layoff_staging
like layoffs;  

insert layoff_staging
select * 
from layoffs

SELECT * from layoff_staging;

select *,
ROW_NUMBER() OVER(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)
from layoff_staging;

with duplicate_cte as
(
select *,
ROW_NUMBER() OVER(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoff_staging
)
select * from duplicate_cte
where row_num > 1;

DELETE 
from duplicate_cte
where row_num > 1;

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * 
from layoff_staging2;

insert into layoff_staging2
select *,
ROW_NUMBER() OVER(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoff_staging;

delete 
from layoff_staging2
where row_num > 1;

select *
from layoff_staging2;

-- standardization
select company, TRIM(company)
from layoff_staging2;

update layoff_staging2
set company = trim(company);

select distinct industry
from layoff_staging2
order by 1;

select *
from layoff_staging2
where industry like 'Crypto %';

select distinct industry
from layoff_staging2
order by 1;

update layoff_staging2
set industry = 'Crypto'
where industry = 'CryptoCurrency'; 

select distinct country
from layoff_staging2
order by 1;

select * 
from layoff_staging2;

update layoff_staging2
set country = 'United States'
WHERE country like 'United States%';

select `date`
-- STR_TO_DATE(`DATE`, '%m/%d/%Y')
from layoff_staging2
order by 1;

UPDATE layoff_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y'); 

alter table layoff_staging2
modify column `date` date;

select *
from layoff_staging2
where industry is null
or industry = '';

select * 
from layoff_staging2
where company = 'Airbnb';

update layoff_staging2
set industry = 'Travel'
where company = 'Airbnb';

select * 
from layoff_staging2
where company = "Bally's Interactive";


select * 
from layoff_staging2
where company = "Carvana";

update layoff_staging2
set industry = 'Transportation'
where company = "Carvana";

select * 
from layoff_staging2
where company = "Juul";

update layoff_staging2
set industry = 'Consumer'
where company = "Juul";

-- 4. remove any columns and rows we need to

select * 
from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null;

-- Delete Useless data we can't really use
delete from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoff_staging2;

alter table layoff_staging2
drop column row_num;