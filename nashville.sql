select * from PortfolioProject..Nashvillehousing

--Standardadize date format
select saledate,convert(date,saledate)  from PortfolioProject..Nashvillehousing

update Nashvillehousing 
set saledate = convert(date,saledate)

--populate property Address data

select * from PortfolioProject..Nashvillehousing
--where propertyaddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress) from PortfolioProject..Nashvillehousing a
join PortfolioProject..Nashvillehousing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = ISNULL(a.PropertyAddress,b.PropertyAddress) from PortfolioProject..Nashvillehousing a
join PortfolioProject..Nashvillehousing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking address into Individual columns (Address,city,state)
select propertyaddress from PortfolioProject..Nashvillehousing

select 
SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyAddress)-1) as address,
SUBSTRING(propertyaddress,CHARINDEX(',',propertyAddress)+1,len(propertyaddress)) as address
from PortfolioProject..Nashvillehousing


alter table Nashvillehousing
add PropertySplitAddress Nvarchar(255)

update Nashvillehousing
set PropertySplitAddress = SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyAddress)-1)

alter table Nashvillehousing
add PropertySplitCity Nvarchar(255)

update Nashvillehousing
set PropertySplitCity = SUBSTRING(propertyaddress,CHARINDEX(',',propertyAddress)+1,len(propertyaddress))


select PropertySplitAddress, PropertySplitCity from PortfolioProject..Nashvillehousing


select owneraddress from PortfolioProject..Nashvillehousing

select
PARSENAME(REPLACE(owneraddress,',','.'),3),
PARSENAME(REPLACE(owneraddress,',','.'),2),
PARSENAME(REPLACE(owneraddress,',','.'),1)
from PortfolioProject..Nashvillehousing

alter table Nashvillehousing
add OwnerSplitAddress Nvarchar(255)

update Nashvillehousing
set OwnerSplitAddress = PARSENAME(REPLACE(owneraddress,',','.'),3)

alter table Nashvillehousing
add OwnerSplitCity Nvarchar(255)

update Nashvillehousing
set OwnerSplitCity = PARSENAME(REPLACE(owneraddress,',','.'),2)


alter table Nashvillehousing
add OwnerSplitState Nvarchar(255)

update Nashvillehousing
set OwnerSplitState = PARSENAME(REPLACE(owneraddress,',','.'),1)

select * from PortfolioProject..Nashvillehousing


-- Change Y and N to Yes and No
select distinct(SoldasVacant),count(soldasvacant) from PortfolioProject..Nashvillehousing
group by SoldAsVacant
order by 2


select soldasvacant,
case 
	when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant
	end
from PortfolioProject..Nashvillehousing

update Nashvillehousing
set SoldAsVacant = case 
	when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant
	end

--Remove Duplicate
with cte as (
select *,
	ROW_NUMBER() over(partition by  ParcelID,
									PropertyAddress,
									SalePrice,
									SaleDate,
									LegalReference
									order by uniqueID
									) row_num
from PortfolioProject..Nashvillehousing
--order by ParcelID
)


select * from cte
where row_num > 1

Delete from cte
where row_num > 1


--Delete unused column duplicates

alter table PortfolioProject..Nashvillehousing
drop column OwnerAddress,TaxDistrict,PropertyAddress

select * from PortfolioProject..Nashvillehousing