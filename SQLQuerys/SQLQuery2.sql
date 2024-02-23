declare @p5 int
set @p5=1
exec dbo.spPrizes_Insert @PlaceNumber=1,@PlaceName=N'uno',@PrizeAmount=100,@PrizePercentage=10,@id=@p5 output
select @p5