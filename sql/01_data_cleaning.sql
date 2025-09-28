-- Data Cleaning Project --

Select * from layoffs;

-- 1 . Remove Duplicates
-- 2. Standardize the Data (correct the spelling errors or other mistakes and fixing it)
-- 3. Null Values or blank values
-- 4. Remove any columns

Create table layoffs_staging Like layoffs;

select * from layoffs_staging;

insert INTO  layoffs_staging select * from layoffs;

select * from layoffs_staging;

-- 1. Remove Duplicates--

select *, row_number() over( partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num from layoffs_staging;

-- Identifying duplicates data

with duplicate_cte as (
select *, row_number() over (
 partition by company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
as row_num from layoffs_staging
) 
select * from duplicate_cte where row_num>1;

CREATE TABLE `layoffs_staging2` (
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

select * from layoffs_staging2;

insert into layoffs_staging2  select *, row_number() over (
 partition by company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
as row_num from layoffs_staging;

select * from layoffs_staging2 where row_num>1;

delete from layoffs_staging2 where row_num>1;

select * from layoffs_staging2;

-- 2. Standardizing the Data (Correcting errors)--

select * from layoffs_staging2;

select distinct industry from layoffs_staging2 order by 1;

select * from layoffs_staging2 where industry LIKE 'Crypto%';

update layoffs_staging2 set industry = 'Crypto' where industry Like 'Crypto%';

select * from layoffs_staging2;

select distinct country from layoffs_staging2 order by 1;

select * from layoffs_staging2 where country LIKE 'United States%';

update layoffs_staging2 set country = 'United States' where country Like 'United States%';

select `date` from layoffs_staging2;

update layoffs_staging2 set `date`=str_to_date(`date`,'%m/%d/%Y') ;

alter table layoffs_staging2 modify column `date` date;

select * from layoffs_staging2;

-- compliacted little bit
select * from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;

select * from layoffs_staging2 where industry is null or industry = '';

select * from layoffs_staging2 where company='Airbnb';

UPDATE layoffs_staging2 SET industry = NULL WHERE industry = '';

select t1.industry, t2.industry from layoffs_staging2 t1 join layoffs_staging t2 on t1.company = t2.company 
where (t1.industry is null or t1.industry = '')
 and t2.industry is not null;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

select * from layoffs_staging2 where company Like 'Bally%';

select * from layoffs_staging2;

-- 4. remove any columns and rows we need to

SELECT * FROM layoffs_staging2 WHERE total_laid_off IS NULL;

SELECT * FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Delete Useless data we can't really use
DELETE FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

select * from layoffs_staging2;

ALTER TABLE layoffs_staging2 DROP COLUMN row_num;

select * from layoffs_staging2;


