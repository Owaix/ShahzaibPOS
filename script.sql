USE [master]
GO
/****** Object:  Database [SaleManagerShahzaibold]    Script Date: 11/8/2021 11:15:36 AM ******/
CREATE DATABASE [SaleManagerShahzaibold]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SaleManagerShahzaibold', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\SaleManagerShahzaibold.mdf' , SIZE = 5184KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SaleManagerShahzaibold_log', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\SaleManagerShahzaibold_log.ldf' , SIZE = 1344KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SaleManagerShahzaibold] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SaleManagerShahzaibold].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SaleManagerShahzaibold] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET ARITHABORT OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET  ENABLE_BROKER 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET  MULTI_USER 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SaleManagerShahzaibold] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SaleManagerShahzaibold] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [SaleManagerShahzaibold]
GO
/****** Object:  StoredProcedure [dbo].[Customer_Select]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[Customer_Select](@customerID int)
as
begin

select Cus.*,Village.VillageName,c.CityName from Customers as Cus
INNER JOIN tbl_city as c on c.Id=Cus.City
INNER JOIN tbl_Village as Village on Village.ID=Cus.Village


where Cus.InActive='false';
end













GO
/****** Object:  StoredProcedure [dbo].[ExpenseVoucherCreate]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ExpenseVoucherCreate]
(@RID  int)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select m.*,c.Amt,c.ChkNo,c.InvNo,c.MOP_ID,c.Narr,c.SlipNo,c.SRT,c.AC_Code as RV_CustomerCode,c.ID from EV_M as m
inner join EV_D as c on m.RID=c.RID
where m.RID=@RID
END









GO
/****** Object:  StoredProcedure [dbo].[ExpenseVoucherEdit]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ExpenseVoucherEdit] 
	-- Add the parameters for the stored procedure here
(@RID  int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select top 1 m.*,c.Amt as amount,c.ChkNo,c.InvNo,c.MOP_ID,c.Narr,c.SlipNo,c.SRT,c.AC_Code as RV_CustomerCode,c.ID from EV_M as m
inner join EV_D as c on m.RID=c.RID
where m.RID=@RID

END









GO
/****** Object:  StoredProcedure [dbo].[ExpenseVoucherIndex]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ExpenseVoucherIndex] 
	-- Add the parameters for the stored procedure here
	
@StartDate datetime,
@EndDate datetime

as
begin
select m.*,c.Amt as amount,rvm.AC_Title as customer,d.AC_Title as cashBAnk,c.ChkNo,c.InvNo,c.MOP_ID,c.Narr,c.SlipNo,c.SRT,c.AC_Code as RV_TransactionCode,c.ID from EV_M as m
inner join EV_D as c on m.RID=c.RID
inner join COA_D as d on d.AC_Code=c.AC_Code
inner join COA_D rvm on rvm.AC_Code=m.AC_Code

where (CAST(m.EDate as Date) >= CAST(@StartDate as Date) and CAST(m.EDate as Date) <= CAST(@EndDate as Date))
END









GO
/****** Object:  StoredProcedure [dbo].[Gen_NewInvNo]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Gen_NewInvNo](@InvType varchar(10))
AS
BEGIN

-----Local Variables

DECLARE @dt varchar(4);
DECLARE @maxID varchar(15);

-----Setup Date YYMM 1510
SET @dt = right(CONVERT(varchar(10),getdate(),10),2) + LEFT(CONVERT(varchar(10),getdate(),10),2);

-----Get max labNo
SELECT TOP(1) @maxID = InvNo from Pur_M WHERE InvNo LIKE @InvType +'-'+ @dt+'%' ORDER BY InvNo DESC

-----Null Fallback, if no labNo for current month
SET @maxID = ISNULL(@maxID,@dt + '000');


-----Increment labNo + 1
SET @maxID = convert(int,Right(@maxID,LEN(@maxID)-7)) + 1;


-----New LabNo
Select @InvType +'-'+ @dt + '' + REPLICATE(0,3 - LEN(@maxID)) + @maxID AS [labNo];

END





GO
/****** Object:  StoredProcedure [dbo].[Gen_NewInvNoLab]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- ============================================ [dbo].[Gen_NewInvNoSale](@InvType varchar(10))
CREATE PROCEDURE  [dbo].[Gen_NewInvNoLab](@InvType varchar(10))
	-- Add the parameters for the stored procedure here
As	
BEGIN
	-----Local Variables

DECLARE @dt varchar(4);
DECLARE @maxID varchar(15);

-----Setup Date YYMM 1510
SET @dt = right(CONVERT(varchar(10),getdate(),10),2) + LEFT(CONVERT(varchar(10),getdate(),10),2);

-----Get max labNo
SELECT TOP(1) @maxID = InvNo from [dbo].[Lab_M] WHERE InvNo LIKE @InvType +'-'+ @dt+'%' ORDER BY InvNo DESC

-----Null Fallback, if no labNo for current month
SET @maxID = ISNULL(@maxID,@dt + '000');


-----Increment labNo + 1
SET @maxID = convert(int,Right(@maxID,LEN(@maxID)-7)) + 1;


-----New LabNo
Select @InvType +'-'+ @dt + '' + REPLICATE(0,3 - LEN(@maxID)) + @maxID AS [labNo];

END



GO
/****** Object:  StoredProcedure [dbo].[Gen_NewInvNoSale]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Gen_NewInvNoSale](@InvType varchar(10))
AS
BEGIN

-----Local Variables

DECLARE @dt varchar(4);
DECLARE @maxID varchar(15);

-----Setup Date YYMM 1510
SET @dt = right(CONVERT(varchar(10),getdate(),10),2) + LEFT(CONVERT(varchar(10),getdate(),10),2);

-----Get max labNo
SELECT TOP(1) @maxID = InvNo from Sales_M WHERE InvNo LIKE @InvType +'-'+ @dt+'%' ORDER BY InvNo DESC

-----Null Fallback, if no labNo for current month
SET @maxID = ISNULL(@maxID,@dt + '000');


-----Increment labNo + 1
SET @maxID = convert(int,Right(@maxID,LEN(@maxID)-7)) + 1;


-----New LabNo
Select @InvType +'-'+ @dt + '' + REPLICATE(0,3 - LEN(@maxID)) + @maxID AS [labNo];

END





GO
/****** Object:  StoredProcedure [dbo].[GenerateLastNo]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GenerateLastNo]
	
AS
BEGIN
	
SELECT TOP 1 ISNULL(RIGHT(OrderNo, LEN(OrderNo) - 1), 0 ) AS OrdrID from tbl_Order 
--where OrderId = 0900
 order by OrdrID desc

END




GO
/****** Object:  StoredProcedure [dbo].[GetAc_Code]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetAc_Code]

@AC_Code int
as
begin

if(@AC_Code= 1)
	BEGIN
	SELECT isnull(Max(AC_Code)+1,1000001) as AC_Code FROM COA_D Where COA_D.CAC_Code=1;
    END

	else if(@AC_Code= 2)
	BEGIN
	SELECT isnull(Max(AC_Code)+1,2000001) as AC_Code FROM COA_D Where COA_D.CAC_Code=2;
    END

	else if (@AC_Code= 3)
	BEGIN
	SELECT isnull(Max(AC_Code)+1,3000001) as AC_Code FROM COA_D Where COA_D.CAC_Code=3;
    END

	else if(@AC_Code= 4)
	BEGIN
	SELECT isnull(Max(AC_Code)+1,4000001) as AC_Code FROM COA_D Where COA_D.CAC_Code=4;
    END

	else if(@AC_Code= 5)
	BEGIN
	SELECT isnull(Max(AC_Code)+1,5000001) as AC_Code FROM COA_D Where COA_D.CAC_Code=5;
    END

	if(@AC_Code= 6)
	BEGIN
	SELECT isnull(Max(AC_Code)+1,6000001) as AC_Code FROM COA_D Where COA_D.CAC_Code=6;
    END

	else if(@AC_Code= 7)
	BEGIN
	SELECT isnull(Max(AC_Code)+1,7000001) as AC_Code FROM COA_D Where COA_D.CAC_Code=7;
    END

	else if(@AC_Code= 8)
	BEGIN
	SELECT isnull(Max(AC_Code)+1,8000001) as AC_Code FROM COA_D Where COA_D.CAC_Code=8;
    END

	else if(@AC_Code= 9)
	BEGIN
	SELECT isnull(Max(AC_Code)+1,9000001) as AC_Code FROM COA_D Where COA_D.CAC_Code=9;
    END

	else if(@AC_Code= 10)
	BEGIN
	SELECT isnull(Max(AC_Code)+1,10000001) as AC_Code FROM COA_D Where COA_D.CAC_Code=10;
    END

	else if(@AC_Code= 11)
	BEGIN
	SELECT isnull(Max(AC_Code)+1,11000001) as AC_Code FROM COA_D Where COA_D.CAC_Code=11;
    END

	if(@AC_Code= 12)
	BEGIN
	SELECT isnull(Max(AC_Code)+1,12000001) as AC_Code FROM COA_D Where COA_D.CAC_Code=12;
    END

	if(@AC_Code= 13)
	BEGIN
	SELECT isnull(Max(AC_Code)+1,13000001) as AC_Code FROM COA_D Where COA_D.CAC_Code=13;
    END

	if(@AC_Code= 14)
	BEGIN
	SELECT isnull(Max(AC_Code)+1,14000001) as AC_Code FROM COA_D Where COA_D.CAC_Code=14;
    END

	if(@AC_Code= 15)
	BEGIN
	SELECT isnull(Max(AC_Code)+1,15000001) as AC_Code FROM COA_D Where COA_D.CAC_Code=15;
    END

	if(@AC_Code= 16)
	BEGIN
	SELECT isnull(Max(AC_Code)+1,16000001) as AC_Code FROM COA_D Where COA_D.CAC_Code=16;
    END

end







GO
/****** Object:  StoredProcedure [dbo].[GetAllAc_Code]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetAllAc_Code]
as
begin

select * from COA_D where CAC_Code =1 or CAC_Code =2 and inActive ='false'

end










GO
/****** Object:  StoredProcedure [dbo].[getCAshBookByDate]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getCAshBookByDate]
	-- Add the parameters for the stored procedure here
	@AcodeMin int,
	@AcodeMax int,
	@StartDate datetime,
@EndDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT gl.GLDate,gl.Debit,gl.Credit,gl.Narration,concat(tt.Symbol, '-',gl.RID  ) as RpCode FROM gl  left join RP tt on gl.TypeCode = tt.TypeCode
WHERE AC_Code BETWEEN @AcodeMin AND @AcodeMax and


(CAST(GLDate as Date) >= CAST(@StartDate as Date) and CAST(GLDate as Date ) <= CAST(@EndDate as Date));

    -- Insert statements for procedure here
	
END





GO
/****** Object:  StoredProcedure [dbo].[getCustomerLedgerBYDate]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





create PROCEDURE [dbo].[getCustomerLedgerBYDate] 
	-- Add the parameters for the stored procedure here
@dtfrom datetime ,@dtto datetime, @acCode int
AS
BEGIN
select GLDate,concat(tt.Symbol, '-',gl.RID  ) as reference,Narration,IPrice,Qty_IN, isnull(debit,0) as debit,isnull(Credit,0) as credit   from GL 
 left join RP tt on gl.TypeCode = tt.TypeCode
 where AC_Code=@acCode and GLDate between @dtfrom AND @dtto order by GLDate;
END




GO
/****** Object:  StoredProcedure [dbo].[getcustomerLedgerSummaryByDate]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[getcustomerLedgerSummaryByDate] 
@dtfrom datetime ,@dtto datetime, @acCode int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select  gl.GLDate ,concat(tt.Symbol, '-',gl.RID  ) as reference,gl.RID,gl.TypeCode, sum(debit) as debit,sum(Credit) as credit   from GL gl 
 left join RP tt on gl.TypeCode = tt.TypeCode
 where AC_Code=@acCode and GLDate between @dtfrom AND @dtto group by  gl.TypeCode,concat(tt.Symbol, '-',gl.RID ),GLDate,gl.RID order by gl.GLDate  ;
END



GO
/****** Object:  StoredProcedure [dbo].[getCustomerPreviousBalance]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[getCustomerPreviousBalance] 

@dtFrom datetime, @acCode int
AS
BEGIN


SELECT
  isnull(SUM( debit),0) as debit,ISNULL( sum(Credit),0) as credit
FROM
    GL
WHERE
    GLDate < @dtFrom and AC_Code=@acCode
END





GO
/****** Object:  StoredProcedure [dbo].[GetExpiredItems]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetExpiredItems]
	-- Add the parameters for the stored procedure here
@ToDate datetime, 

@FromDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select Itemledger.ExpDT,Itemledger.CTN
      ,Itemledger.PCS
      ,Itemledger.[OPN] ,Items.IName
       from Itemledger
	   
	    left join Items on Itemledger.IID= Items.IID 
		 where  Itemledger.TypeCode=2 and
		 
		 (CAST(Itemledger.ExpDT as Date) >= CAST(@ToDate as Date) and CAST(Itemledger.ExpDT as Date ) <= CAST(@FromDate as Date))

	
 
END





GO
/****** Object:  StoredProcedure [dbo].[getItemAdjustment]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getItemAdjustment] 
	-- Add the parameters for the stored procedure here
	@dtfrom datetime ,@dtto datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select Adj_M.EDate ,COA_D.AC_Title as Account ,COA_D.AC_Code as AccountID,Items.IName as product,Items.AC_Code_Inv as productCode,Items.IID as productID,tbl_Warehouse.Warehouse as warehouse ,tbl_Warehouse.WID as warehouseID ,Adj_M.RID ,Adj_D.Qty as QtyIN , Adj_D.Qty2 as QtyOut


,Adj_D.PurPrice , Adj_D.Debit ,Adj_D.Credit from Adj_M

inner join Adj_D on Adj_M.RID=Adj_D.RID

inner join tbl_Warehouse on tbl_Warehouse.WID=Adj_M.WID

inner join COA_D on COA_D.AC_Code=Adj_M.AC_Code

inner join Items on Items.IID=Adj_D.IID
where

CAST(Adj_M.EDate AS DATE) BETWEEN CAST(@dtfrom AS DATE) AND CAST(@dtto AS DATE)

order by Adj_M.EDate
END





GO
/****** Object:  StoredProcedure [dbo].[getJournalVoucherRecord]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getJournalVoucherRecord] 
	-- Add the parameters for the stored procedure here
		@StartDate datetime,
@EndDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT jv.AC_Code,jv.AC_Code2,jv.Narr,jv.Amt,jm.EDate ,jv.RID from JV_D as jv left join JV_M as jm on jv.RID=jm.RID

	where 

(CAST( [EDate]as Date) >= CAST(@StartDate as Date) and CAST(@StartDate as Date ) <= CAST(@EndDate as Date));
END



GO
/****** Object:  StoredProcedure [dbo].[getMaxACodeById]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getMaxACodeById]
	-- Add the parameters for the stored procedure here
	@cac_Code int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	select ISNULL(max(AC_Code),0) from COA_D where CAC_Code=@cac_Code

END





GO
/****** Object:  StoredProcedure [dbo].[getMinACodeById]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getMinACodeById]
	-- Add the parameters for the stored procedure here
	@cac_Code int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	select ISNULL(min(AC_Code),0) from COA_D where CAC_Code=@cac_Code

END





GO
/****** Object:  StoredProcedure [dbo].[getMonthDays]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getMonthDays]
	   @Month int,
        @Year int
AS
BEGIN
	




select DATEADD(month,@Month-1,DATEADD(year,@Year-1900,0))as ToDate,DATEADD(day,-1,DATEADD(month,@Month,DATEADD(year,@Year-1900,0))) as FromDate
END





GO
/****** Object:  StoredProcedure [dbo].[getOpdRecords]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getOpdRecords]
	-- Add the parameters for the stored procedure here
	@StartDate datetime,
@EndDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from tbl_Opd 
	where 

(CAST( [DateTime]as Date) >= CAST(@StartDate as Date) and CAST(@StartDate as Date ) <= CAST(@EndDate as Date));
END



GO
/****** Object:  StoredProcedure [dbo].[getPaidRecordByMonth]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getPaidRecordByMonth]
	-- Add the parameters for the stored procedure here
		@StartDate datetime,
		@EndDate datetime
AS
BEGIN

select c.CusName, SUM(g.Credit) AS [TOTAL AMOUNT],c.AC_Code
from Customers c left join GL g

 ON c.AC_Code= g.AC_Code

 where  g.[GLDate]  between @StartDate and @EndDate
 GROUP BY c.CusName , c.AC_Code
END





GO
/****** Object:  StoredProcedure [dbo].[getProfitAndLoss]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getProfitAndLoss] 

	@AcodeMin int,
	@AcodeMax int,
	@StartDate datetime,
@EndDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select sum(GL.Debit) as debit,sum(GL.Credit) as Credit,COA_D.AC_Code,COA_D.AC_Title from GL left join COA_D on GL.AC_Code= COA_D.AC_Code

	


	WHERE GL.AC_Code BETWEEN @AcodeMin AND @AcodeMax and


(CAST(GL.GLDate as Date) >= CAST(@StartDate as Date) and CAST(GLDate as Date ) <= CAST(@EndDate as Date))

group by COA_D.AC_Code , COA_D.AC_Title;
END



GO
/****** Object:  StoredProcedure [dbo].[getStockByID]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getStockByID]
	-- Add the parameters for the stored procedure here
   @id	int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
select ISNULL(sum(OPN),0)+ISNULL(sum(pj),0)-ISNULL(sum(PRJ),0)- ISNULL(sum(SJ),0) +ISNULL(sum(SRJ),0) +  ISNULL(sum(SCH_IN),0) 
   -  ISNULL(sum(SCH_Out),0) +  ISNULL(sum(ADJ_IN),0) -  ISNULL(sum(ADJ_OUT),0) +ISNULL(sum(TR_IN),0) - ISNULL(sum(TR_OUT),0) +
    ISNULL( sum(MFG_IN),0)  -ISNULL( sum(MFG_OUT),0) as total

from  [dbo].[Itemledger] where IID=@id
   
END





GO
/****** Object:  StoredProcedure [dbo].[getVendorLedgerBYDate]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[getVendorLedgerBYDate]
	-- Add the parameters for the stored procedure here
@dtfrom datetime ,@dtto datetime, @acCode int
AS
BEGIN
select GLDate,concat(tt.Symbol, '-',gl.RID  ) as reference,Narration,IPrice,Qty_IN, isnull(debit,0) as debit,isnull(Credit,0) as credit   from GL 
 left join RP tt on gl.TypeCode = tt.TypeCode
 where AC_Code=@acCode and GLDate between @dtfrom AND @dtto order by GLDate;
END





GO
/****** Object:  StoredProcedure [dbo].[getVendorPreviousBalance]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create PROCEDURE [dbo].[getVendorPreviousBalance] 
	-- Add the parameters for the stored procedure here
@dtFrom datetime, @acCode int
AS
BEGIN


SELECT
  isnull(SUM( debit),0) as debit,ISNULL( sum(Credit),0) as credit
FROM
    GL
WHERE
    GLDate < @dtFrom and AC_Code=@acCode
END








GO
/****** Object:  StoredProcedure [dbo].[Item_select]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Item_select]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	 select i.AC_Code_Inv,i.IName,c.Cat,u.IUnit,i.IID from Items as i inner join Items_Cat as c on i.SCatID=CatID inner join IUnit as u on i.Unit_ID= u.unit_id where i.isDeleted='false'
END









GO
/****** Object:  StoredProcedure [dbo].[Item_Summary]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Item_Summary] --'2018/3/13','2018/3/13 23:59:59','Admin'
@reportStartDate DateTime 
, @reportEndDate DateTime ,
@Item varchar(20) 

AS
Select OrderNo , OrderDate , IName, Items.IID , SUM(Qty) as Qty , SUM(Rate) as Rate from tbl_Order
inner join tbl_KOT on tbl_KOT.Id = tbl_Order.KOTID
inner join tbl_OrderDetails on tbl_OrderDetails.OrderId = tbl_Order.OrderId
inner join Items on Items.IID = tbl_OrderDetails.itemID
WHERE
		('0' = @Item OR Items.IID LIKE @Item)
	AND tbl_Order.OrderDate BETWEEN @reportStartDate AND @reportEndDate
group by IName , OrderNo , OrderDate ,Items.IID
order by OrderNo




GO
/****** Object:  StoredProcedure [dbo].[LabList]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[LabList]
	-- Add the parameters for the stored procedure here
	@StartDate datetime,
@EndDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select D.AC_Title ,S.* from Lab_M as S left join COA_D D on S.AC_Code = D.AC_Code
	where 

	(CAST(S.EDate as Date) >= CAST(@StartDate as Date) and CAST(S.EDate as Date ) <= CAST(@EndDate as Date));
END



GO
/****** Object:  StoredProcedure [dbo].[PaymentVoucharEdit]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[PaymentVoucharEdit](@RID  int)
as
begin
select top 1 m.*,c.Amt,c.BalAmt,c.checkDate,c.ChkNo,c.DisAmt,c.InvNo,c.MOP_ID,c.Narr,c.PreAmt,c.SlipNo,c.SRT,c.AC_Code as RV_CustomerCode,c.ID from PV_M as m
inner join PV_D as c on m.RID=c.RID
where m.RID=@RID

end










GO
/****** Object:  StoredProcedure [dbo].[PaymentVoucharIndex]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[PaymentVoucharIndex]
@StartDate datetime,
@EndDate datetime

as
begin
select m.*,c.Amt,rvm.AC_Title as customer,d.AC_Title as cashBAnk,c.BalAmt,c.checkDate,c.ChkNo,c.DisAmt,c.InvNo,c.MOP_ID,c.Narr,c.PreAmt,c.SlipNo,c.SRT,c.AC_Code as RV_TransactionCode,c.ID from PV_M as m
inner join PV_D as c on m.RID=c.RID
inner join COA_D as d on d.AC_Code=c.AC_Code
inner join COA_D rvm on rvm.AC_Code=m.AC_Code

where (CAST(m.EDate as Date) >= CAST(@StartDate as Date) and CAST(m.EDate as Date) <= CAST(@EndDate as Date))

end










GO
/****** Object:  StoredProcedure [dbo].[PurchaseEDit]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  proc [dbo].[PurchaseEDit]--1,1
(@rid int,@id int)
as
begin 
select '' as MyJson,'' as PurJson,ch.Comm,ch.Total,ch.CvenID,cV.VendName as cVendName,spds.VillageID as  SaleVillageID,spds.VendorID as cusID,spds.CityID as SalecityID,spds.KhamBikri,spds.LongerTadat,spds.Phaliyan,spds.PukhtaBikri,spds.Sale_ID,spds.CustomerExpense, m.*,ch.Pur_ID,ch.VendorID,ch.ItemID,ch.UnitID,ch.Quantity,ch.Pur_Price,ch.Pur_Total,v.*,i.IName , unit.IUnit as Unites from Sale_Pur_M as m
inner join Sale_Pur_D_Pur as ch on m.RId=ch.RID
inner join Vendors V on v.VID=ch.VendorID
inner join items i on i.IID=ch.ItemID
inner join Sale_Pur_D_Sale spds on m.RId=spds.RID
inner join Vendors cV on cV.VID= ch.CvenID
left join IUnit unit on unit.unit_id = i.Unit_ID
where ch.RID=@rid
end




GO
/****** Object:  StoredProcedure [dbo].[PurchaseList]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[PurchaseList]
	-- Add the parameters for the stored procedure here
	@StartDate datetime,
@EndDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select D.AC_Title ,S.* from Pur_M as S left join COA_D D on S.AC_Code = D.AC_Code
	where 

	(CAST(S.EDate as Date) >= CAST(@StartDate as Date) and CAST(S.EDate as Date ) <= CAST(@EndDate as Date));
END



GO
/****** Object:  StoredProcedure [dbo].[RecivedVoucharEdit]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[RecivedVoucharEdit](@RID  int)
as
begin
select top 1  m.*,c.Amt,c.BalAmt,c.checkDate,c.ChkNo,c.DisAmt,c.InvNo,c.MOP_ID,c.Narr,c.PreAmt,c.SlipNo,c.SRT,c.AC_Code as RV_CustomerCode,c.ID from RV_M as m
inner join RV_d as c on m.RID=c.RID
where m.RID=@RID
end










GO
/****** Object:  StoredProcedure [dbo].[RecivedVoucharIndex]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE proc [dbo].[RecivedVoucharIndex]
@StartDate datetime,
@EndDate datetime

as
begin
select m.*,c.Amt,rvm.AC_Title as customer,d.AC_Title as cashBAnk,c.BalAmt,c.checkDate,c.ChkNo,c.DisAmt,c.InvNo,c.MOP_ID,c.Narr,c.PreAmt,c.SlipNo,c.SRT,c.AC_Code as RV_TransactionCode,c.ID from RV_M as m
inner join RV_d as c on m.RID=c.RID
inner join COA_D as d on d.AC_Code=c.AC_Code
inner join COA_D rvm on rvm.AC_Code=m.AC_Code

where (CAST(m.EDate as Date) >= CAST(@StartDate as Date) and CAST(m.EDate as Date) <= CAST(@EndDate as Date))
END





GO
/****** Object:  StoredProcedure [dbo].[Report_BookingDetailSummary]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Report_BookingDetailSummary]
@reportStartDate DateTime 
, @reportEndDate DateTime ,
@userName nvarchar(50) ,
@type varchar(20) 

AS

SELECT 
	OrderNo , Amount , OrderDate , OrderType  , PR.KOTID , us.UserName , GST , Discount
	 , 	Items.IName , Qty as Qty , Rate as Rate  
FROM 
	tbl_Order PR
	INNER JOIN AspNetUsers us ON us.Id = PR.UserID
	inner join tbl_KOT on tbl_KOT.Id = PR.KOTID
	inner join tbl_OrderDetails on tbl_OrderDetails.OrderId = PR.OrderId
	inner join Items on Items.IID = tbl_OrderDetails.itemID
	
	
WHERE
		('All' = @userName OR us.[UserName] LIKE @userName)
	AND ('0' = @type OR PR.[KOTID] LIKE @type)
	AND PR.OrderDate BETWEEN @reportStartDate AND @reportEndDate




GO
/****** Object:  StoredProcedure [dbo].[Report_BookingSummary]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Report_BookingSummary] --'2018/3/13','2018/3/13 23:59:59','Admin'
@reportStartDate DateTime 
, @reportEndDate DateTime ,
@userName nvarchar(50) ,
@type varchar(20) 

AS

SELECT 
	OrderNo , Amount , OrderDate , OrderType  , KOTID , us.UserName , GST , Discount	
FROM 
	tbl_Order PR
	INNER JOIN AspNetUsers us ON us.Id = PR.UserID
	
	
WHERE
		('All' = @userName OR us.[UserName] LIKE @userName)
	AND ('0' = @type OR PR.[KOTID] LIKE @type)
	AND PR.OrderDate BETWEEN @reportStartDate AND @reportEndDate




GO
/****** Object:  StoredProcedure [dbo].[Report_BookingSummary_Summary]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Report_BookingSummary_Summary]
	@reportStartDate DateTime 
, @reportEndDate DateTime ,
@userName nvarchar(50) 
AS
	SELECT 
	SUM(data.billCountBydoctor) AS billCountBydoctor,
	SUM(data.discCountbydoctor) AS discCountbydoctor,
	data.Authorized_By

	 FROM 
	(
	SELECT 
	''  AS  userName, --userName ,
	'' AS labno
	,CAST('1/1/1900' AS datetime) AS  [Date], 
	'' AS Stat
	,'' AS 'Patient'
	,ISNULL(d.docName,'') AS 'Authorized_By'
	,CAST(0 AS int) AS 'reportID'
	,CAST(0 AS DECIMAL) AS 'Gross'
	,CAST(0 AS DECIMAL) AS 'Disc'
	,CAST(0 AS DECIMAL) AS 'Net_Amount'
	,CAST(0 AS DECIMAL) AS 'Amt' 
	,CAST(0 AS DECIMAL) AS 'BAL'
	,@reportStartDate AS dtStart ,@reportEndDate AS dtEnd 
	,CASE WHEN discountRate = 100  THEN COUNT(Distinct(PR.patientID)) ELSE 0 END AS billCountBydoctor
	,CASE WHEN discountRate = 50  THEN COUNT(Distinct(PR.patientID)) ELSE 0 END AS discCountbydoctor

FROM 
	PatientReports PR
	INNER JOIN Doctors d ON PR.docID = d.docID
WHERE
	('All' = @userName OR PR.[crtBy] LIKE @userName )
	AND PR.crtDate BETWEEN @reportStartDate AND @reportEndDate
GROUP  by
	
	d.docName,pr.[discountRate]
	) as data

	GROUP  by
	
	data.Authorized_By

RETURN 0




GO
/****** Object:  StoredProcedure [dbo].[Report_CategoryandLabWiseTest]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Report_CategoryandLabWiseTest] --'2017/2/1','2018/2/28','all'
  @reportStartDate DateTime 
, @reportEndDate DateTime ,
  @userName nvarchar(50) 
AS
	
Select labno  ,MRI , UltraSound ,CTScan, XRay  from
(
Select pr.LabNo as labno ,l.reportID as Total_Test , t.testcategoryName as category from PatientReports pr
Left JOIN Patients p ON p.patientID = pr.patientID
Left JOIN LabReports l ON l.reportID = pr.reportID 
Left JOIN TestCategory t ON t.testCategoryID = l.testCategoryID 
WHERE
	('All' = @userName OR pr.[crtBy] LIKE @userName)
	AND pr.crtDate BETWEEN @reportStartDate AND @reportEndDate
) as SourceTable
PIVOT (
  COUNT(Total_Test)
  FOR category
  IN(MRI , UltraSound ,CTScan, XRay )

) as BookingSummary




GO
/****** Object:  StoredProcedure [dbo].[SaleList]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaleList]
	-- Add the parameters for the stored procedure here
	@StartDate datetime,
@EndDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select D.AC_Title ,S.* from Sales_M as S left join COA_D D on S.AC_Code = D.AC_Code
	where 

	(CAST(S.EDate as Date) >= CAST(@StartDate as Date) and CAST(S.EDate as Date ) <= CAST(@EndDate as Date));
END



GO
/****** Object:  StoredProcedure [dbo].[SalePurchaseDetails]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SalePurchaseDetails]--1004
(@rid int)
as
begin 
select ch.Pur_ID,ch.VendorID,ch.ItemID,ch.UnitID,ch.Quantity,ch.Pur_Price,ch.Pur_Total,v.*,i.IName, V2.VendName as CVendName,c.CityName,vill.VillageName ,ch.Comm from  Sale_Pur_D_Pur as ch
left join Vendors V on v.VID=ch.VendorID
left join Vendors V2 on V2.VID=ch.CvenID
left join items i on i.IID=ch.ItemID
left join tbl_Village vill on vill.ID=v.Village
left join tbl_city C on C.Id=V.Village
where ch.RID=@rid
end









GO
/****** Object:  StoredProcedure [dbo].[SalePurchaseIndex]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SalePurchaseIndex](@dtfrom datetime,@dtto datetime, @pageNumber int,@pageSize int)

as
begin 
select spds.*, m.[Date], m.[Date]as dtfrom, m.[Date]as dtto, m.VehicalNo,m.Rent,m.Total_Purchase, v.*
	,@pageNumber as [PageNumber]
	,@pageSize as [PageSize]
	,CONVERT(int, COUNT(*) OVER()) AS [PageCount]
	from Sale_Pur_M as m
inner join Sale_Pur_D_Sale as spds on m.RId=spds.RID
inner join customers V on v.CID=spds.VendorID
where m.[Date]>=@dtfrom and m.[Date]<=@dtto

order by m.RId desc OFFSET @PageSize * (@PageNumber - 1) ROWS
FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
end












GO
/****** Object:  StoredProcedure [dbo].[sp_AcCode_Insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_AcCode_Insert]
	-- Add the parameters for the stored procedure here
	@CAC_Code int ,@PType_ID int,@ZID int,@AC_Code int,@AC_Title varchar(255),@DR float,@CR float,@Qty int,@InActive bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
insert into COA_D (CAC_Code,PType_ID,ZID,AC_Code,AC_Title,DR,CR,Qty,InActive) values(@CAC_Code,@PType_ID,@ZID,@AC_Code,@AC_Title,@DR,@CR,@Qty,@InActive)

    -- Insert statements for procedure here
	
END









GO
/****** Object:  StoredProcedure [dbo].[sp_catergories_Delete]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_catergories_Delete]
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update Items_Cat set isDeleted='true' where CatID=@Id;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_catergories_Insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_catergories_Insert]
	-- Add the parameters for the stored procedure here

@Name varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into Items_Cat (Cat,isDeleted) values(@Name,'false');
END









GO
/****** Object:  StoredProcedure [dbo].[sp_catergories_Select]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_catergories_Select]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from Items_Cat where isDeleted = 'false';
END









GO
/****** Object:  StoredProcedure [dbo].[sp_catergories_SelectByID]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_catergories_SelectByID]
	-- Add the parameters for the stored procedure here
@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from Items_Cat where CatID=@Id;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_catergories_update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_catergories_update]
	-- Add the parameters for the stored procedure here
	@Id int ,
	@Name varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update Items_Cat set Cat=@Name where CatID=@Id;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_city_Delete]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_city_Delete]
	-- Add the parameters for the stored procedure here
@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		update tbl_city set isDeleted='true' where Id=@Id;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_City_insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_City_insert]
	-- Add the parameters for the stored procedure here
@Name varchar(55)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into tbl_city(CityName,isDeleted) values(@Name,'false');
END









GO
/****** Object:  StoredProcedure [dbo].[sp_City_Select]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_City_Select]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from tbl_city where isDeleted = 'false';
END









GO
/****** Object:  StoredProcedure [dbo].[sp_city_selectByID]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_city_selectByID]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		select * from tbl_city where Id=@Id;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_City_update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_City_update]-- Add the parameters for the stored procedure here
	@Name varchar(55),
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		update tbl_city set CityName=@Name where Id=@Id;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_COA_D_Delete]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_COA_D_Delete]
	-- Add the parameters for the stored procedure here
	@AC int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
 update COA_D set InActive ='true'   where  AC_Code = @AC;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_coa_d_selectByAcCode]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_coa_d_selectByAcCode]
	-- Add the parameters for the stored procedure here
	@code int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from COA_D where AC_Code=@code
END









GO
/****** Object:  StoredProcedure [dbo].[sp_COA_D_SelectByCode]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_COA_D_SelectByCode]
	-- Add the parameters for the stored procedure here
	@CAC_Code int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select * from COA_D where CAC_Code =@CAC_Code and InActive='false';
END









GO
/****** Object:  StoredProcedure [dbo].[sp_COA_D_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_COA_D_Update]


 @AC_Code int ,@PType_ID int,@ZID int,@AC_Title varchar(255),@DR float,@CR float,@Qty int,@InActive bit
 as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update [dbo].[COA_D] set PType_ID= @PType_ID,ZID=@ZID,AC_Title=@AC_Title,DR=@DR,CR=@CR,Qty=@Qty,InActive=@InActive
	
	 where AC_Code=@AC_Code
	-- Add the parameters for the stored procedure here


END









GO
/****** Object:  StoredProcedure [dbo].[sp_COA_M_Select]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_COA_M_Select] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from COA_M
END









GO
/****** Object:  StoredProcedure [dbo].[sp_company_Delete]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_company_Delete]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update IComp_M set [isDelete] ='true' where CompID =@id
END









GO
/****** Object:  StoredProcedure [dbo].[Sp_company_Insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_company_Insert] 
	-- Add the parameters for the stored procedure here
	@Comp varchar(255),@CShort varchar(255),@Address varchar(255),@Tel varchar(255),@Eml varchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into IComp_M (Comp,CShort,[Address],[Tel],[Eml],[isDelete]) values(@Comp,@CShort,@Address,@Tel,@Eml,'false');
END









GO
/****** Object:  StoredProcedure [dbo].[Sp_company_Select]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_company_Select]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from IComp_M where isDelete ='false'
END









GO
/****** Object:  StoredProcedure [dbo].[Sp_company_SelectByID]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_company_SelectByID]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from IComp_M where CompID = @id
END









GO
/****** Object:  StoredProcedure [dbo].[Sp_company_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_company_Update]
	-- Add the parameters for the stored procedure here
	@Comp varchar(255),@CShort varchar(255),@Address varchar(255),@Tel varchar(255),@Eml varchar(255), @id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update IComp_M set Comp=@Comp,CShort=@CShort,[Address]=@Address,[Tel] =@Tel,[Eml]=@Eml where CompID = @id
END









GO
/****** Object:  StoredProcedure [dbo].[Sp_Crud_Catergories]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Crud_Catergories] 
	-- Add the parameters for the stored procedure here
@Opertion varchar(50),
@Id int ,
@Name varchar(50),
@isDeleted bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if(@Opertion = 'insert')
	BEGIN
	insert into Items_Cat (Cat,isDeleted) values('shahazaib','false');
    END

	else if(@Opertion = 'select')
	BEGIN
	select * from Items_Cat where isDeleted = 'false';
    END


	else if(@Opertion = 'Delete')
	BEGIN
	update Items_Cat set isDeleted='true' where CatID=@Id;
    END

	else if(@Opertion = 'Update')
	BEGIN
	update Items_Cat set Cat=@Name where CatID=@Id;
    END

	else if(@Opertion = 'SelectByID')
	BEGIN
	select * from Items_Cat where CatID=1;
    END
	


	
END









GO
/****** Object:  StoredProcedure [dbo].[sp_customer_COA_D_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_customer_COA_D_Update] 
	-- Add the parameters for the stored procedure here
	@Name varchar(255),
	@AC_Code int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 update COA_D set
		   [AC_Title]=@Name where AC_Code=@AC_Code;

END









GO
/****** Object:  StoredProcedure [dbo].[sp_Customer_Delete]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Customer_Delete]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 update Customers set
		   InActive='true' where CID=@id
END









GO
/****** Object:  StoredProcedure [dbo].[sp_customer_Gl_insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_customer_Gl_insert]
	-- Add the parameters for the stored procedure here
	@RID int
           ,@RID2 int
           ,@TypeCode int
           ,@GLDate date
           
         
           ,@AC_Code int
           ,@AC_Code2 int
           ,@Narration  nvarchar(255)
  
           ,@Debit float
           ,@Credit float
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	   INSERT INTO [dbo].[GL]
           ([RID]
           ,[RID2]
           ,[TypeCode]
           ,[GLDate]
           
         
           ,[AC_Code]
           ,[AC_Code2]
           ,[Narration]
           
         
           
           
           ,[Debit]
           ,[Credit]
         )
     VALUES(@RID 
           ,@RID2 
           ,@TypeCode 
           ,@GLDate 
           
         
           ,@AC_Code 
           ,@AC_Code2 
           ,@Narration  
  
           ,@Debit
           ,@Credit );
         
END









GO
/****** Object:  StoredProcedure [dbo].[sp_customer_Gl_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_customer_Gl_Update]
	-- Add the parameters for the stored procedure here
	@Debit float,
	@Credit float,
	@AC_Code int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	       update GL set
		   Debit=@Debit , Credit=@Credit where AC_Code=@AC_Code and TypeCode=0;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_customer_Gl_Update_Capital]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_customer_Gl_Update_Capital]
	-- Add the parameters for the stored procedure here
		-- Add the parameters for the stored procedure here
	@Debit float,
	@Credit float,
	@AC_Code int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	       update GL set
		   Debit=@Debit , Credit=@Credit where AC_Code2=@AC_Code and TypeCode=0;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_Customer_insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Customer_insert]
	-- Add the parameters for the stored procedure here
	
	@AC_Code int,@CusName varchar(55),@PType_ID int,@Add varchar(250),@NTN_No varchar(55),@ContactPerson varchar(55)
   ,@Owner_Name varchar(55),@Cell varchar(55),@Eml varchar(55),@Tel varchar(55),@SID int,
	@ZID int,@AddPer varchar(55),@Debit float
   ,@Credit float,@Black_List bit,@War_Cls varchar(55),@War_DT varchar(55),
    @Prn varchar(55),@InActive bit,@Land varchar(55),@City int,@Village int


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO Customers
           (AC_Code,CusName,PType_ID,[Add],NTN_No,ContactPerson,Owner_Name,Cell,Eml,Tel,[SID],ZID,AddPer,Debit
		   ,Credit,Black_List,War_Cls,War_DT,Prn,InActive,Land,City,Village
		   )

		   values(
		   @AC_Code,@CusName,@PType_ID,@Add,@NTN_No,@ContactPerson,@Owner_Name,@Cell,@Eml,@Tel,@SID,@ZID,@AddPer,@Debit
		   ,@Credit,@Black_List,@War_Cls,@War_DT,@Prn,@InActive,@Land,@City,@Village);
    
END









GO
/****** Object:  StoredProcedure [dbo].[sp_customer_selectById]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_customer_selectById] 
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select Cus.*,Village.VillageName,c.CityName from Customers as Cus
INNER JOIN tbl_city as c on c.Id=Cus.City
INNER JOIN tbl_Village as Village on Village.ID=Cus.Village

where Cus.CID=@id and Cus.InActive='false';
END









GO
/****** Object:  StoredProcedure [dbo].[sp_Customer_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Customer_Update]
	-- Add the parameters for the stored procedure here
	@AC_Code int,@CusName varchar(55),@PType_ID int,@Add varchar(250),@NTN_No varchar(55),
	@ContactPerson varchar(55),@Owner_Name varchar(55),@Cell varchar(55),@Eml varchar(55),
	@Tel varchar(55),@SID int,@ZID int,@AddPer varchar(55),@Debit float,@Credit float,@Black_List bit,
	@War_Cls varchar(55),@War_DT varchar(55),@Prn varchar(55),@InActive bit,@Land varchar(55),@City int,
	@Village int

AS
BEGIN
	
	update Customers set AC_Code=@AC_Code,CusName=@CusName,PType_ID=@PType_ID,
	[Add]=@Add,NTN_No=@NTN_No,ContactPerson=@ContactPerson,Owner_Name=@Owner_Name,
	Cell=@Cell,Eml=@Eml,Tel=@Tel,[SID]=@SID,ZID=@ZID,AddPer=@AddPer,Debit=@Debit
   ,Credit=@Credit,Black_List=@Black_List,War_Cls=@War_Cls,War_DT=@War_DT,Prn=@Prn,InActive=@InActive,Land=@Land,
	City=@City,Village=@Village

    where AC_Code=@AC_Code;

  
END









GO
/****** Object:  StoredProcedure [dbo].[sp_getArticle]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_getArticle] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	select ArticleTypes.ArticleTypeID,Styles.StyleID,Styles.StyleName,ArticleTypes.ArticleTypeName,Article.ArticleNo,Article.ProductName,Article.IsDelete,Article.ProductID

	from Article inner join  ArticleTypes on Article.ArticleTypeID=ArticleTypes.ArticleTypeID

	inner join Styles on Styles.StyleID = Article.StyleID;
END





GO
/****** Object:  StoredProcedure [dbo].[sp_Item_COA_D_Cost_of_Sale_Insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Item_COA_D_Cost_of_Sale_Insert]
	-- Add the parameters for the stored procedure here
	@CAC_Code int,@PType_ID int,@ZID int,@AC_Code int,@AC_Title varchar(255),@DR float,@CR float,@Qty float
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into COA_D (CAC_Code,PType_ID,ZID,AC_Code,AC_Title,DR,CR,Qty,InActive) values(@CAC_Code ,@PType_ID ,@ZID ,@AC_Code ,@AC_Title,@DR ,@CR ,@Qty,'false' )
END









GO
/****** Object:  StoredProcedure [dbo].[sp_Item_COA_D_Cost_of_Sale_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Item_COA_D_Cost_of_Sale_Update]
	-- Add the parameters for the stored procedure here
	@CostOfSale int,
	@Name varchar(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update COA_D set AC_Title = @Name from COA_D where AC_Code=@CostOfSale
END









GO
/****** Object:  StoredProcedure [dbo].[sp_Item_COA_D_Incomecode_Insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Item_COA_D_Incomecode_Insert]
	-- Add the parameters for the stored procedure here
	@CAC_Code int,@PType_ID int,@ZID int,@AC_Code int,@AC_Title varchar(255),@DR float,@CR float,@Qty float
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into COA_D (CAC_Code,PType_ID,ZID,AC_Code,AC_Title,DR,CR,Qty,InActive) values(@CAC_Code ,@PType_ID ,@ZID ,@AC_Code ,@AC_Title,@DR ,@CR ,@Qty,'false' )
END









GO
/****** Object:  StoredProcedure [dbo].[sp_Item_COA_D_Incomecode_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Item_COA_D_Incomecode_Update]
	-- Add the parameters for the stored procedure here
	@Incomecode int,
	@Name varchar(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update COA_D set AC_Title = @Name from COA_D where AC_Code=@Incomecode
END









GO
/****** Object:  StoredProcedure [dbo].[sp_Item_COA_D_InventoryCode_Insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Item_COA_D_InventoryCode_Insert]
	-- Add the parameters for the stored procedure here
	@CAC_Code int,@PType_ID int,@ZID int,@AC_Code int,@AC_Title varchar(255),@DR float,@CR float,@Qty float
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into COA_D (CAC_Code,PType_ID,ZID,AC_Code,AC_Title,DR,CR,Qty,InActive) values(@CAC_Code ,@PType_ID ,@ZID ,@AC_Code ,@AC_Title,@DR ,@CR ,@Qty,'false' )
END









GO
/****** Object:  StoredProcedure [dbo].[sp_Item_COA_D_Inventorycode_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Item_COA_D_Inventorycode_Update]
	-- Add the parameters for the stored procedure here
	@Inventorycode int,
	@Name varchar(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update COA_D set AC_Title = @Name from COA_D where AC_Code=@Inventorycode
END









GO
/****** Object:  StoredProcedure [dbo].[sp_Item_Delete]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Item_Delete]
	-- Add the parameters for the stored procedure here
@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 update Items set isDeleted ='true'   where IID=@id;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_Item_Gl_Insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Item_Gl_Insert]
	-- Add the parameters for the stored procedure here
	@RID int
           ,@RID2 int
           ,@TypeCode int
           ,@GLDate date
           
         
           ,@AC_Code int
           ,@AC_Code2 int
           ,@Narration  nvarchar(255)
         ,@OP_Price float
           ,@Debit float
           ,@Credit float
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	   INSERT INTO [dbo].[GL]
           ([RID]
           ,[RID2]
           ,[TypeCode]
           ,[GLDate]
           
         
           ,[AC_Code]
           ,[AC_Code2]
           ,[Narration]
           ,[Qty_IN]
         
           
           
           ,[Debit]
           ,[Credit]
         )
     VALUES(@RID 
           ,@RID2 
           ,@TypeCode 
           ,@GLDate 
            ,@AC_Code 
           ,@AC_Code2 
           ,@Narration  
           ,@OP_Price
           ,@Debit
           ,@Credit );
		   
END







GO
/****** Object:  StoredProcedure [dbo].[sp_Item_Insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Item_Insert]
	-- Add the parameters for the stored procedure here
	@IName varchar(250) ,@Desc varchar(250),@Unit_ID int,@Inv_YN bit,@CompID int,@BarCode_ID varchar(250),@SCatID int,@CTN_PCK int,@PurPrice float,@SalesPrice float,@RetailPrice float,@ICP int,@OP_Qty int,@OP_Price int,@DisContinue int,@AC_Code_Inv int,@AC_Code_Inc int,@AC_Code_Cost int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into Items  (IName,[Desc],Unit_ID,Inv_YN,CompID,BarCode_ID,SCatID,CTN_PCK,PurPrice,SalesPrice,RetailPrice,ICP,OP_Qty,OP_Price,DisContinue,AC_Code_Inv,AC_Code_Inc,AC_Code_Cost,isDeleted) values(@IName,@Desc,@Unit_ID,@Inv_YN,@CompID,@BarCode_ID,@SCatID,@CTN_PCK,@PurPrice,@SalesPrice,@RetailPrice,@ICP,@OP_Qty,@OP_Price,@DisContinue,@AC_Code_Inv,@AC_Code_Inc,@AC_Code_Cost,'false')
END









GO
/****** Object:  StoredProcedure [dbo].[SP_Items]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Items]
	@Param nvarchar(50)

AS
BEGIN
	
SELECT TOP 10 Items.IID , ISNULL(ArticleNo, '0') as ArticleNo, Items.IName, ISNULL(Color, 0) as Color, ISNULL(Size, 0) as Size,ISNULL(IComp_M.Comp , '') as Comp,ISNULL(Items.Formula , '') as Formula
FROM Items
left join Article on Items.IID = Article.ProductID
left join Colors on Items.Color = Colors.ColorID
left join Sizes on Items.Size = Sizes.SizeID
left join IComp_M on Items.CompID = IComp_M.CompID
where Items.IName like '%'+ @Param +'%'
								 OR Article.ArticleNo like '%'+ @Param +'%'
                                 OR Colors.Name like '%'+ @Param +'%'
								 OR Sizes.SizeName like '%'+ @Param +'%'
                                 OR IComp_M.Comp like '%'+ @Param +'%'
								 OR Items.Formula like '%'+ @Param +'%'
END



GO
/****** Object:  StoredProcedure [dbo].[sp_Items_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Items_Update]
	-- Add the parameters for the stored procedure here
	@Name varchar(250) ,@Desc varchar(250),@Unit_ID int,@Inv_YN bit,@CompID int,@BarCode_ID varchar(250),@SCatID int,@CTN_PCK int,@PurPrice float,@SalesPrice float,@RetailPrice float,@ICP int,@OP_Qty int,@OP_Price int,@DisContinue int,@AC_Code_Inv int,@AC_Code_Inc int,@AC_Code_Cost int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update Items set IName=@Name,[Desc]=@Desc,Unit_ID=@Unit_ID,Inv_YN=@Inv_YN,CompID=@CompID,BarCode_ID=@BarCode_ID,SCatID=@SCatID,CTN_PCK=@CTN_PCK,PurPrice=@PurPrice,SalesPrice=@SalesPrice,RetailPrice=@RetailPrice,ICP=@ICP,OP_Qty=@OP_Qty,OP_Price=@OP_Price,DisContinue=@DisContinue,AC_Code_Inv=@AC_Code_Inv,AC_Code_Inc=@AC_Code_Inc,AC_Code_Cost=@AC_Code_Cost where AC_Code_Inv=@AC_Code_Inv
END









GO
/****** Object:  StoredProcedure [dbo].[sp_PartyType_Delete]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_PartyType_Delete]
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update Party_Type set isDeleted='true' where PType_ID=@Id;
	
end









GO
/****** Object:  StoredProcedure [dbo].[sp_PartyType_insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_PartyType_insert]
	-- Add the parameters for the stored procedure here
	@Name varchar(55)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into Party_Type(Party_Type,isDeleted) values(@Name,'false');
END









GO
/****** Object:  StoredProcedure [dbo].[Sp_partyType_Select]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_partyType_Select]
	-- Add the parameters for the stored procedure here
	@PType_ID int, @Party_Type varchar(100), @isDeleted bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from Party_Type as a
	WHERE
	(0 = @PType_ID OR a.PType_ID LIKE @PType_ID)
	AND ('' = @Party_Type OR a.Party_Type LIKE @Party_Type)
	AND (1 = @isDeleted OR a.isDeleted LIKE @isDeleted)
END







GO
/****** Object:  StoredProcedure [dbo].[sp_partyType_SelectById]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_partyType_SelectById]
	-- Add the parameters for the stored procedure here
	@PType_ID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select * from Party_Type where PType_ID=@PType_ID;
END







GO
/****** Object:  StoredProcedure [dbo].[sp_PartyType_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_PartyType_Update]
	-- Add the parameters for the stored procedure here
	@id int,
	@Name Varchar(55)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update Party_Type set Party_Type=@Name where PType_ID=@Id;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_PV_D_Insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_PV_D_Insert]

@RID int ,@Narr Varchar(250) ,@MOP_ID int,@AC_Code int,@InvNo int,@ChkNo int,@SlipNo int,
@PreAmt float,@Amt float,@DisAmt float,@BalAmt float,@SRT float,@RCancel float,@checkDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into PV_D (RID,Narr,MOP_ID,AC_Code,InvNo,ChkNo,SlipNo,PreAmt,Amt,DisAmt,BalAmt,SRT,RCancel,checkDate,IsDeleted) 
	
	values(@RID,@Narr,@MOP_ID,@AC_Code,@InvNo,@ChkNo,@SlipNo,@PreAmt,@Amt,@DisAmt,@BalAmt,@SRT,@RCancel,@checkDate,'false')
END










GO
/****** Object:  StoredProcedure [dbo].[sp_PV_D_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_PV_D_Update]

-- Add the parameters for the stored procedure here
	@RID int ,@Narr Varchar(250) ,@MOP_ID int,@AC_Code int,@InvNo int,@ChkNo int,@SlipNo int,
@PreAmt float,@Amt float,@DisAmt float,@BalAmt float,@SRT float,@RCancel float,@checkDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update PV_D set Narr =@Narr,MOP_ID =@MOP_ID,AC_Code=@AC_Code,InvNo=@InvNo,ChkNo=@ChkNo,SlipNo=@SlipNo,PreAmt=PreAmt,
	Amt=@Amt,DisAmt=@DisAmt,BalAmt=@BalAmt,SRT=@SRT,RCancel=@RCancel,checkDate=@checkDate where RID=@RID
end









GO
/****** Object:  StoredProcedure [dbo].[sp_PV_GL_credit]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_PV_GL_credit]
	-- Add the parameters for the stored procedure here
	@TypeCode int,@AC_Code int,@AC_Code2 int,@Narration varchar(255),@Debit float,@Credit float,@RID int, @gl datetime ,@MOP_ID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
insert into GL (TypeCode,AC_Code,AC_Code2,Narration,Debit,Credit,RID,GLDate,MOP_ID) values(@TypeCode,@AC_Code,@AC_Code2,@Narration,@Debit,@Credit,@RID,@gl,@MOP_ID);
END









GO
/****** Object:  StoredProcedure [dbo].[sp_PV_Gl_Credit_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_PV_Gl_Credit_Update]
	-- Add the parameters for the stored procedure here
		@TypeCode int,@AC_Code int,@AC_Code2 int,@Narration varchar(250),@Debit float,@Credit float,@RID int, @gldate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update GL set AC_Code=@AC_Code,AC_Code2=@AC_Code2,Narration=@Narration,Debit=@Debit,Credit=@Credit,GLDate=@gldate

	where TypeCode=@TypeCode and RID=@RID and AC_Code=@AC_Code
END









GO
/****** Object:  StoredProcedure [dbo].[sp_PV_GL_Debit]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_PV_GL_Debit]
	-- Add the parameters for the stored procedure here
	@TypeCode int,@AC_Code int,@AC_Code2 int,@Narration varchar(255),@Debit float,@Credit float,@RID int , @gl datetime, @MOP_ID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
insert into GL (TypeCode,AC_Code,AC_Code2,Narration,Debit,Credit,RID,GLDate ,MOP_ID) values(@TypeCode,@AC_Code,@AC_Code2,@Narration,@Debit,@Credit,@RID,@gl,@MOP_ID);
END









GO
/****** Object:  StoredProcedure [dbo].[sp_PV_Gl_Debit_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_PV_Gl_Debit_Update]
	-- Add the parameters for the stored procedure here
		@TypeCode int,@AC_Code int,@AC_Code2 int,@Narration varchar(250),@Debit float,@Credit float,@RID int, @gldate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update GL set AC_Code=@AC_Code,AC_Code2=@AC_Code2,Narration=@Narration,Debit=@Debit,Credit=@Credit,GLDate=@gldate

	where TypeCode=@TypeCode and RID=@RID and AC_Code=@AC_Code
END









GO
/****** Object:  StoredProcedure [dbo].[sp_PV_M_Insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_PV_M_Insert]
	-- Add the parameters for the stored procedure here
	@CompID int ,@EDate datetime,@AC_Code int,@SID int ,@Rem varchar(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	
	insert into PV_M (CompID,EDate,AC_Code,[SID],Rem,isDeleted) values (@CompID,@EDate,@AC_Code,@SID,@Rem,'false')

	SELECT SCOPE_IDENTITY()
END









GO
/****** Object:  StoredProcedure [dbo].[sp_PV_M_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_PV_M_Update]
	-- Add the parameters for the stored procedure here
	@CompID int ,@EDate datetime,@AC_Code int,@SID int ,@Rem varchar(250) ,@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update PV_M set
	CompID=@CompID,EDate=@EDate,AC_Code =@AC_Code,[SID]=@SID,Rem=@Rem where RID= @Id
END









GO
/****** Object:  StoredProcedure [dbo].[sp_RV_D_Insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_RV_D_Insert]

@RID int ,@Narr Varchar(250) ,@MOP_ID int,@AC_Code int,@InvNo int,@ChkNo int,@SlipNo int,
@PreAmt float,@Amt float,@DisAmt float,@BalAmt float,@SRT float,@RCancel float,@checkDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into RV_D (RID,Narr,MOP_ID,AC_Code,InvNo,ChkNo,SlipNo,PreAmt,Amt,DisAmt,BalAmt,SRT,RCancel,checkDate,IsDeleted) 
	
	values(@RID,@Narr,@MOP_ID,@AC_Code,@InvNo,@ChkNo,@SlipNo,@PreAmt,@Amt,@DisAmt,@BalAmt,@SRT,@RCancel,@checkDate,'false')
END









GO
/****** Object:  StoredProcedure [dbo].[sp_RV_D_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_RV_D_Update]-- Add the parameters for the stored procedure here
	@RID int ,@Narr Varchar(250) ,@MOP_ID int,@AC_Code int,@InvNo int,@ChkNo int,@SlipNo int,
@PreAmt float,@Amt float,@DisAmt float,@BalAmt float,@SRT float,@RCancel float,@checkDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update RV_D set Narr =@Narr,MOP_ID =@MOP_ID,AC_Code=@AC_Code,InvNo=@InvNo,ChkNo=@ChkNo,SlipNo=@SlipNo,PreAmt=PreAmt,
	Amt=@Amt,DisAmt=@DisAmt,BalAmt=@BalAmt,SRT=@SRT,RCancel=@RCancel,checkDate=@checkDate where RID=@RID
END









GO
/****** Object:  StoredProcedure [dbo].[sp_RV_GL_credit]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_RV_GL_credit]
	-- Add the parameters for the stored procedure here
	@TypeCode int,@AC_Code int,@AC_Code2 int,@Narration varchar(250),@Debit float,@Credit float,@RID int ,@gl datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
insert into GL (TypeCode,AC_Code,AC_Code2,Narration,Debit,Credit,RID,GLDate) values(@TypeCode,@AC_Code,@AC_Code2,@Narration,@Debit,@Credit,@RID,@gl);
END









GO
/****** Object:  StoredProcedure [dbo].[sp_RV_Gl_Credit_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_RV_Gl_Credit_Update]
	-- Add the parameters for the stored procedure here
		@TypeCode int,@AC_Code int,@AC_Code2 int,@Narration varchar(250),@Debit float,@Credit float,@RID int, @gldate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update GL set AC_Code=@AC_Code,AC_Code2=@AC_Code2,Narration=@Narration,Debit=@Debit,Credit=@Credit,GLDate=@gldate

	where TypeCode=@TypeCode and RID=@RID and AC_Code=@AC_Code
END









GO
/****** Object:  StoredProcedure [dbo].[sp_RV_GL_Debit]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_RV_GL_Debit] 
	-- Add the parameters for the stored procedure here
	@TypeCode int,@AC_Code int,@AC_Code2 int,@Narration varchar(250),@Debit float,@Credit float,@RID int ,@gl datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
insert into GL (TypeCode,AC_Code,AC_Code2,Narration,Debit,Credit,RID,GLDate) values(@TypeCode,@AC_Code,@AC_Code2,@Narration,@Debit,@Credit,@RID,@gl);
END









GO
/****** Object:  StoredProcedure [dbo].[sp_RV_Gl_Debit_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_RV_Gl_Debit_Update]
	-- Add the parameters for the stored procedure here
		@TypeCode int,@AC_Code int,@AC_Code2 int,@Narration varchar(250),@Debit float,@Credit float,@RID int, @gldate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update GL set AC_Code=@AC_Code,AC_Code2=@AC_Code2,Narration=@Narration,Debit=@Debit,Credit=@Credit,GLDate=@gldate

	where TypeCode=@TypeCode and RID=@RID and AC_Code=@AC_Code
END









GO
/****** Object:  StoredProcedure [dbo].[sp_RV_M_Insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_RV_M_Insert]
	-- Add the parameters for the stored procedure here
	@CompID int ,@EDate datetime,@AC_Code int,@SID int ,@Rem varchar(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

insert into RV_M (CompID,EDate,AC_Code,[SID],Rem,isDeleted ) values (@CompID,@EDate,@AC_Code,@SID,@Rem,'false' ) 
	SELECT SCOPE_IDENTITY()
 	
END









GO
/****** Object:  StoredProcedure [dbo].[sp_RV_M_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_RV_M_Update]
	-- Add the parameters for the stored procedure here
	@CompID int ,@EDate datetime,@AC_Code int,@SID int ,@Rem varchar(250) ,@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update RV_M set
	CompID=@CompID,EDate=@EDate,AC_Code =@AC_Code,[SID]=@SID,Rem=@Rem where RID= @Id
END









GO
/****** Object:  StoredProcedure [dbo].[sp_Unit_delete]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Unit_delete]
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
update IUnit set active='true' where unit_id=@Id;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_unit_insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_unit_insert]
	-- Add the parameters for the stored procedure here
	@Name varchar(55)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into IUnit(IUnit,active) values(@Name,'false');
END









GO
/****** Object:  StoredProcedure [dbo].[sp_unit_select]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_unit_select] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from IUnit where active = 'false';
END









GO
/****** Object:  StoredProcedure [dbo].[sp_unit_selectById]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_unit_selectById]
	-- Add the parameters for the stored procedure here
	
@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from IUnit where unit_id=@Id;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_unit_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_unit_Update]
	-- Add the parameters for the stored procedure here
@Id int ,
@Name varchar(55)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update IUnit set IUnit=@Name where unit_id=@Id;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_vendor_coa_d_update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_vendor_coa_d_update]
	-- Add the parameters for the stored procedure here
	@Name varchar(255),
	@AC_Code int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 update COA_D set
		   [AC_Title]=@Name where AC_Code=@AC_Code;

end









GO
/****** Object:  StoredProcedure [dbo].[sp_vendor_delete]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_vendor_delete]
	-- Add the parameters for the stored procedure here
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 update Vendors set
		   InActive='true' where VID=@id

end









GO
/****** Object:  StoredProcedure [dbo].[sp_Vendor_Gl_insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Vendor_Gl_insert]
	-- Add the parameters for the stored procedure here
	
	@RID int
           ,@RID2 int
           ,@TypeCode int
           ,@GLDate date
           
         
           ,@AC_Code int
           ,@AC_Code2 int
           ,@Narration  nvarchar(255)
  
           ,@Debit float
           ,@Credit float
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	   INSERT INTO [dbo].[GL]
           ([RID]
           ,[RID2]
           ,[TypeCode]
           ,[GLDate]
           
         
           ,[AC_Code]
           ,[AC_Code2]
           ,[Narration]
           
         
           
           
           ,[Debit]
           ,[Credit]
         )
     VALUES(@RID 
           ,@RID2 
           ,@TypeCode 
           ,@GLDate 
           
         
           ,@AC_Code 
           ,@AC_Code2 
           ,@Narration  
  
           ,@Debit
           ,@Credit );
END









GO
/****** Object:  StoredProcedure [dbo].[sp_vendor_gl_update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_vendor_gl_update]
   @Debit float,
	@Credit float,
	@AC_Code int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	       update GL set
		   Debit=@Debit , Credit=@Credit where AC_Code=@AC_Code and TypeCode=0;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_vendor_Gl_Update_capital]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_vendor_Gl_Update_capital]
	-- Add the parameters for the stored procedure here
	@Debit float,
	@Credit float,
	@AC_Code int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	       update GL set
		   Debit=@Debit , Credit=@Credit where AC_Code2=@AC_Code and TypeCode=0;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_vendor_insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_vendor_insert]
	-- Add the parameters for the stored procedure here
		@AC_Code int,@CusName varchar(55),@PType_ID int,@Add varchar(250),@NTN_No varchar(55),@ContactPerson varchar(55)
   ,@Cell varchar(55),@Eml varchar(55),@Tel varchar(55),
	@ZID int,@Debit float
   ,@Credit float,@InActive bit,@Land varchar(55),@City int,@Village int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
INSERT INTO Vendors
           (AC_Code,VendName,PType_ID,[Add],NTN_No,ContactPerson,Cell,Eml,Tel,ZID,Debit
		   ,Credit,InActive,Land,City,Village
		   )

		   values(
		   @AC_Code,@CusName,@PType_ID,@Add,@NTN_No,@ContactPerson,@Cell,@Eml,@Tel,@ZID,@Debit
		   ,@Credit,@InActive,@Land,@City,@Village);


END









GO
/****** Object:  StoredProcedure [dbo].[sp_vendor_selectById]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_vendor_selectById]

	-- Add the parameters for the stored procedure here
	@vendorID int
	as

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select v.*,Village.VillageName,c.CityName from Vendors as V
INNER JOIN tbl_city as c on c.Id=v.City
INNER JOIN tbl_Village as Village on Village.ID=v.Village

where v.VID= @vendorID;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_vendor_update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_vendor_update]
	-- Add the parameters for the stored procedure here
			@AC_Code int,@CusName varchar(55),@PType_ID int,@Add varchar(250),@NTN_No varchar(55),@ContactPerson varchar(55)
   ,@Cell varchar(55),@Eml varchar(55),@Tel varchar(55),
	@ZID int,@Debit float
   ,@Credit float,@InActive bit,@Land varchar(55),@City int,@Village int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
update Vendors set AC_Code=@AC_Code,VendName=@CusName,PType_ID=@PType_ID,
	[Add]=@Add,NTN_No=@NTN_No,ContactPerson=@ContactPerson,
	Cell=@Cell,Eml=@Eml,Tel=@Tel,ZID=@ZID,Debit=@Debit
   ,Credit=@Credit,InActive=@InActive,Land=@Land,
	City=@City,Village=@Village

    where AC_Code=@AC_Code;
END









GO
/****** Object:  StoredProcedure [dbo].[sp_Village_Delete]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Village_Delete]
	-- Add the parameters for the stored procedure here
 @id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update tbl_Village set IsDeleted='true' where ID=@id
END









GO
/****** Object:  StoredProcedure [dbo].[sp_Village_Insert]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Village_Insert]
	-- Add the parameters for the stored procedure here
@CityID int,
@VillageName varchar(100),@IsDeleted bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into tbl_Village 

	   ([CityID],[VillageName],[IsDeleted]
         )
     VALUES(@CityID 
           ,@VillageName 
           ,@IsDeleted
		   )

END









GO
/****** Object:  StoredProcedure [dbo].[sp_Village_SelectByID]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Village_SelectByID]
	-- Add the parameters for the stored procedure here
	@ID int 
	
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from tbl_Village where ID=@ID
END









GO
/****** Object:  StoredProcedure [dbo].[sp_village_Update]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_village_Update]
	-- Add the parameters for the stored procedure here
	@City int, @VillageNAme Varchar(250) ,@ID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Update tbl_Village set [CityID]=@City ,[VillageName] =@VillageNAme where ID =@ID
END









GO
/****** Object:  StoredProcedure [dbo].[Update_EV]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Update_EV]
	-- Add the parameters for the stored procedure here
@Rid int ,
@EDate datetime,
@Ac_code float,
@CustomerCode varchar(55),
@Amount float,
@checkNO varchar(55),
@Narr varchar(55)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update EV_M set AC_Code=@Ac_code ,EDate=@EDate where RID=@Rid;

	update EV_D set AC_Code=@CustomerCode, ChkNo=@checkNO,Amt=@Amount,Narr=@Narr where RID=RID
END









GO
/****** Object:  StoredProcedure [dbo].[UpdateItemTable]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateItemTable] 
	-- Add the parameters for the stored procedure here
	
	@Name varchar(100), 
	@CatertoryId varchar(100),
	@UnitID varchar(100),
	@ItemID  int,
	@Inventorycode varchar(100),
	@Incomecode varchar(100),
	@CostOfSale varchar (100)
AS
BEGIN
	update Items set IName=@Name , SCatID=@CatertoryId, Unit_ID= @UnitID  from Items where IID = @ItemID

	update COA_D set AC_Title = @Name from COA_D where AC_Code=@Inventorycode

	update COA_D set AC_Title = @Name from COA_D where AC_Code=@Incomecode

	update COA_D set AC_Title = @Name from COA_D where AC_Code=@CostOfSale

END










GO
/****** Object:  StoredProcedure [dbo].[Vendor_Select]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Vendor_Select](@vendorID int)
as
begin

select v.*,Village.VillageName,c.CityName from Vendors as V
INNER JOIN tbl_city as c on c.Id=v.City
INNER JOIN tbl_Village as Village on Village.ID=v.Village

where v.InActive='false';

end









GO
/****** Object:  StoredProcedure [dbo].[Village_Select]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Village_Select] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	select v.ID,v.VillageName,c.CityName  from tbl_Village as v inner join tbl_city as c on v.CityID=c.Id where v.IsDeleted='false'
END









GO
/****** Object:  Table [dbo].[Adj_D]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Adj_D](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[IID] [int] NULL,
	[BNID] [varchar](max) NULL,
	[ExpDT] [varchar](max) NULL,
	[Qty] [float] NULL,
	[Qty2] [float] NULL,
	[PurPrice] [float] NULL,
	[Debit] [float] NULL,
	[Credit] [float] NULL,
	[SRT] [float] NULL,
	[RCancel] [float] NULL,
	[Adj_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Adj_M]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Adj_M](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[CompID] [int] NULL,
	[EDate] [datetime] NULL,
	[AC_Code] [int] NULL,
	[WID] [int] NULL,
	[RefNo] [varchar](max) NULL,
	[Rem] [varchar](max) NULL,
	[Posted] [float] NULL,
	[APost] [float] NULL,
	[RCancel] [float] NULL,
	[Create_User_ID] [float] NULL,
	[Create_Date] [datetime] NULL,
	[Edit_User_ID] [float] NULL,
	[Edit_Date] [datetime] NULL,
	[Del_User_ID] [varchar](max) NULL,
	[Del_Date] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Article]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Article](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ArticleTypeID] [int] NULL,
	[StyleID] [int] NULL,
	[BrandID] [int] NULL,
	[ProductName] [varchar](max) NULL,
	[ProductImage] [varchar](max) NULL,
	[ArticleNo] [varchar](max) NULL,
	[Description] [varchar](max) NULL,
	[IsDelete] [bit] NULL,
	[BranchID] [int] NULL,
	[CreatedBy] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifyBy] [varchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ArticleTypes]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ArticleTypes](
	[ArticleTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ArticleTypeName] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](max) NULL,
	[ModifiedBy] [varchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ArticleTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AspNetRole]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AspNetRole](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUser]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AspNetUser](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Email] [varchar](max) NULL,
	[EmailConfirmed] [bit] NULL,
	[PasswordHash] [varchar](max) NULL,
	[SecurityStamp] [varchar](max) NULL,
	[PhoneNumber] [varchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NULL,
	[TwoFactorEnabled] [bit] NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NULL,
	[AccessFailedCount] [int] NULL,
	[UserName] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AspNetUserClaim]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AspNetUserClaim](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [varchar](max) NULL,
	[ClaimType] [varchar](max) NULL,
	[ClaimValue] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserLogin]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AspNetUserLogin](
	[LoginProvider] [int] IDENTITY(1,1) NOT NULL,
	[ProviderKey] [varchar](max) NULL,
	[UserId] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserRole]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AspNetUserRole](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[COA_D]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[COA_D](
	[CAC_Code] [int] IDENTITY(1,1) NOT NULL,
	[PType_ID] [int] NULL,
	[ZID] [int] NULL,
	[AC_Code] [int] NULL,
	[AC_Title] [varchar](max) NULL,
	[DR] [float] NULL,
	[CR] [float] NULL,
	[Qty] [float] NULL,
	[InActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[CAC_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[COA_M]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[COA_M](
	[MAC_Code] [int] IDENTITY(1,1) NOT NULL,
	[MTitle] [varchar](max) NULL,
	[SubAC_Code] [float] NULL,
	[SubTitle] [varchar](max) NULL,
	[CAC_Code] [int] NULL,
	[CATitle] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[MAC_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Colors]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Colors](
	[ColorID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](max) NULL,
	[ShortName] [varchar](max) NULL,
	[BranchID] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](max) NULL,
	[ModifiedBy] [varchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
	[IID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ColorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customers](
	[AC_Code] [int] NULL,
	[CID] [int] NULL,
	[CusName] [varchar](max) NULL,
	[PType_ID] [int] NULL,
	[Add] [varchar](max) NULL,
	[NTN_No] [varchar](max) NULL,
	[ContactPerson] [varchar](max) NULL,
	[Owner_Name] [varchar](max) NULL,
	[Cell] [varchar](max) NULL,
	[Eml] [varchar](max) NULL,
	[Tel] [varchar](max) NULL,
	[SID] [int] NULL,
	[ZID] [int] NULL,
	[AddPer] [varchar](max) NULL,
	[Debit] [float] NULL,
	[Credit] [float] NULL,
	[Black_List] [bit] NULL,
	[War_Cls] [varchar](max) NULL,
	[War_DT] [varchar](max) NULL,
	[Prn] [varchar](max) NULL,
	[InActive] [bit] NULL,
	[Land] [varchar](max) NULL,
	[City] [int] NULL,
	[Village] [int] NULL,
	[CompanyID] [int] NULL,
	[CollectPerMonth] [decimal](20, 2) NULL,
	[MrNO] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EV_D]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EV_D](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[Narr] [varchar](max) NULL,
	[MOP_ID] [varchar](max) NULL,
	[AC_Code] [varchar](max) NULL,
	[InvNo] [varchar](max) NULL,
	[ChkNo] [varchar](max) NULL,
	[SlipNo] [varchar](max) NULL,
	[Amt] [varchar](max) NULL,
	[SRT] [varchar](max) NULL,
	[RCancel] [varchar](max) NULL,
	[ID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EV_M]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EV_M](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[CompID] [float] NULL,
	[EDate] [datetime] NULL,
	[AC_Code] [float] NULL,
	[SID] [float] NULL,
	[AC_Code2] [varchar](max) NULL,
	[AC_Code3] [varchar](max) NULL,
	[Amt] [varchar](max) NULL,
	[Rem] [varchar](max) NULL,
	[Posted] [float] NULL,
	[APost] [float] NULL,
	[RCancel] [float] NULL,
	[Create_User_ID] [varchar](max) NULL,
	[Create_Date] [varchar](max) NULL,
	[Edit_User_ID] [varchar](max) NULL,
	[Edit_Date] [varchar](max) NULL,
	[Del_User_ID] [varchar](max) NULL,
	[Del_Date] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Excptions]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Excptions](
	[ExpID] [int] IDENTITY(1,1) NOT NULL,
	[ExcptionName] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ExpID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GL]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GL](
	[SRT] [int] NULL,
	[RID] [int] NULL,
	[RID2] [int] NULL,
	[TypeCode] [int] NULL,
	[GLDate] [datetime] NULL,
	[DueDT] [datetime] NULL,
	[CompID] [int] NULL,
	[SID] [int] NULL,
	[AC_Code] [int] NULL,
	[AC_Code2] [int] NULL,
	[Narration] [varchar](max) NULL,
	[Rem] [varchar](max) NULL,
	[MOP_ID] [int] NULL,
	[ChkNo] [int] NULL,
	[SlipNo] [int] NULL,
	[Qty_IN] [float] NULL,
	[Qty_Out] [float] NULL,
	[IPrice] [float] NULL,
	[PAmt] [float] NULL,
	[DisP] [float] NULL,
	[DisAmt] [float] NULL,
	[DisRs] [float] NULL,
	[Debit] [float] NULL,
	[Credit] [float] NULL,
	[VehNo] [varchar](max) NULL,
	[Post_User_ID] [int] NULL,
	[Post_Date] [datetime] NULL,
	[GL_id] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[I_Unit]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[I_Unit](
	[unit_id] [int] IDENTITY(1,1) NOT NULL,
	[IUnit] [varchar](max) NULL,
	[active] [bit] NULL,
	[crtBy] [varchar](max) NULL,
	[crtDate] [datetime] NULL,
	[modBy] [varchar](max) NULL,
	[modDate] [varchar](max) NULL,
	[CompanyID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[unit_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IComp_M]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IComp_M](
	[CompID] [int] IDENTITY(1,1) NOT NULL,
	[Comp] [varchar](max) NULL,
	[CShort] [varchar](max) NULL,
	[Address] [varchar](max) NULL,
	[Tel] [varchar](max) NULL,
	[Eml] [varchar](max) NULL,
	[isDelete] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[CompID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Item_Maker]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Item_Maker](
	[MakerId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](max) NULL,
	[Address] [varchar](max) NULL,
	[CompanyID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MakerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Itemledger]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Itemledger](
	[SRT] [int] NULL,
	[TypeCode] [int] NULL,
	[RID] [int] NULL,
	[EDate] [datetime] NULL,
	[AC_CODE] [int] NULL,
	[WID] [int] NULL,
	[SID] [int] NULL,
	[IID] [int] NULL,
	[BNID] [int] NULL,
	[ExpDT] [datetime] NULL,
	[CTN] [float] NULL,
	[PCS] [float] NULL,
	[OPN] [float] NULL,
	[PJ] [float] NULL,
	[PRJ] [float] NULL,
	[SJ] [float] NULL,
	[SRJ] [float] NULL,
	[SCH_IN] [float] NULL,
	[SCH_Out] [float] NULL,
	[SCH_Out2] [float] NULL,
	[ADJ_IN] [float] NULL,
	[ADJ_OUT] [float] NULL,
	[TR_IN] [float] NULL,
	[TR_OUT] [float] NULL,
	[MFG_IN] [float] NULL,
	[MFG_OUT] [float] NULL,
	[PurPrice] [float] NULL,
	[SalesPriceP] [float] NULL,
	[AddPer] [float] NULL,
	[AddAmt] [float] NULL,
	[SalesPrice] [float] NULL,
	[PAmt] [float] NULL,
	[DisP] [float] NULL,
	[DisAmt] [float] NULL,
	[DisRs] [float] NULL,
	[Amt] [float] NULL,
	[Amt2] [float] NULL,
	[RCancel] [float] NULL,
	[LegderId] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Items]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Items](
	[IID] [int] IDENTITY(1,1) NOT NULL,
	[IName] [varchar](max) NULL,
	[Desc] [varchar](max) NULL,
	[Unit_ID] [int] NULL,
	[Inv_YN] [bit] NULL,
	[CompID] [int] NULL,
	[BarCode_ID] [varchar](max) NULL,
	[SCatID] [int] NULL,
	[CTN_PCK] [float] NULL,
	[PurPrice] [float] NULL,
	[SalesPrice] [float] NULL,
	[RetailPrice] [float] NULL,
	[ICP] [int] NULL,
	[OP_Qty] [float] NULL,
	[OP_Price] [float] NULL,
	[DisContinue] [float] NULL,
	[AC_Code_Inv] [int] NULL,
	[AC_Code_Inc] [int] NULL,
	[AC_Code_Cost] [int] NULL,
	[isDeleted] [bit] NULL,
	[CompanyID] [int] NULL,
	[saleTax] [int] NULL,
	[Color] [int] NULL,
	[Size] [int] NULL,
	[ArticleNoID] [int] NULL,
	[BarcodeNo] [varchar](max) NULL,
	[DisP] [decimal](20, 2) NULL,
	[DisR] [decimal](20, 2) NULL,
	[AveragePrice] [float] NULL,
	[Demand] [float] NULL,
	[ArticleTypeId] [int] NULL,
	[Style] [int] NULL,
	[RetailPOne] [decimal](20, 2) NULL,
	[RetailPTwo] [decimal](20, 2) NULL,
	[RetailPThree] [decimal](20, 2) NULL,
	[Formula] [varchar](max) NULL,
	[Img] [varchar](max) NULL,
	[WholeSale] [decimal](20, 2) NULL,
	[itemName] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[IID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Items_Cat]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Items_Cat](
	[CatID] [int] IDENTITY(1,1) NOT NULL,
	[Cat] [varchar](max) NULL,
	[isDeleted] [bit] NULL,
	[CompanyID] [int] NULL,
	[img] [varchar](max) NULL,
	[Images] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[CatID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IUnit]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IUnit](
	[unit_id] [int] IDENTITY(1,1) NOT NULL,
	[IUnit1] [varchar](max) NULL,
	[active] [bit] NULL,
	[crtBy] [varchar](max) NULL,
	[crtDate] [datetime] NULL,
	[modBy] [varchar](max) NULL,
	[modDate] [varchar](max) NULL,
	[CompanyID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[unit_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[JV_D]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[JV_D](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[Narr] [varchar](max) NULL,
	[MOP_ID] [int] NULL,
	[AC_Code] [int] NULL,
	[AC_Code2] [int] NULL,
	[InvNo] [varchar](max) NULL,
	[ChkNo] [varchar](max) NULL,
	[SlipNo] [varchar](max) NULL,
	[Amt] [float] NULL,
	[SRT] [varchar](max) NULL,
	[RCancel] [varchar](max) NULL,
	[id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[JV_M]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[JV_M](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[CompID] [float] NULL,
	[EDate] [datetime] NULL,
	[SID] [float] NULL,
	[Rem] [varchar](max) NULL,
	[APost] [float] NULL,
	[Posted] [float] NULL,
	[RCancel] [float] NULL,
	[Create_User_ID] [varchar](max) NULL,
	[Create_Date] [varchar](max) NULL,
	[Edit_User_ID] [varchar](max) NULL,
	[Edit_Date] [varchar](max) NULL,
	[Del_User_ID] [varchar](max) NULL,
	[Del_Date] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Lab_D]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Lab_D](
	[SD_ID] [int] IDENTITY(1,1) NOT NULL,
	[RID] [float] NULL,
	[IID] [float] NULL,
	[BNID] [float] NULL,
	[ExpDT] [datetime] NULL,
	[CTN] [varchar](max) NULL,
	[PCS] [float] NULL,
	[SCH] [varchar](max) NULL,
	[Qty] [float] NULL,
	[PurPrice] [float] NULL,
	[SalesPriceP] [float] NULL,
	[AddPer] [varchar](max) NULL,
	[AddAmt] [varchar](max) NULL,
	[SalesPrice] [float] NULL,
	[PAmt] [float] NULL,
	[DisP] [varchar](max) NULL,
	[DisAmt] [varchar](max) NULL,
	[DisRs] [varchar](max) NULL,
	[Amt2] [float] NULL,
	[Amt] [float] NULL,
	[PCK_Det] [float] NULL,
	[SRT] [float] NULL,
	[RCancel] [float] NULL,
	[ReportDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[SD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Lab_M]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Lab_M](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[CompID] [float] NULL,
	[RID2] [varchar](max) NULL,
	[EDate] [datetime] NULL,
	[CAC_Code] [varchar](max) NULL,
	[AC_Code] [float] NULL,
	[Ship_To] [varchar](max) NULL,
	[Ship_ID] [varchar](max) NULL,
	[Trans_ID] [varchar](max) NULL,
	[BiltyNo] [varchar](max) NULL,
	[SID] [float] NULL,
	[WID] [float] NULL,
	[Rem] [varchar](max) NULL,
	[NetAmt2] [float] NULL,
	[DisAmt] [varchar](max) NULL,
	[PreBal] [float] NULL,
	[NetAmt] [float] NULL,
	[AC_Code3] [varchar](max) NULL,
	[CashAmt] [varchar](max) NULL,
	[APost] [float] NULL,
	[Posted] [float] NULL,
	[RCancel] [float] NULL,
	[War_Cls] [float] NULL,
	[Create_User_ID] [float] NULL,
	[Create_Date] [datetime] NULL,
	[Edit_User_ID] [float] NULL,
	[Edit_Date] [datetime] NULL,
	[Del_User_ID] [varchar](max) NULL,
	[Del_Date] [varchar](max) NULL,
	[InvNo] [varchar](max) NULL,
	[InvDT] [datetime] NULL,
	[InvType] [varchar](max) NULL,
	[CstId] [int] NULL,
	[TotalAmount] [decimal](20, 2) NULL,
	[CstInvNo] [varchar](max) NULL,
	[VenInvDate] [varchar](max) NULL,
	[TransportExpense] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Party_Type]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Party_Type](
	[PType_ID] [int] IDENTITY(1,1) NOT NULL,
	[Party_Type1] [varchar](max) NULL,
	[isDeleted] [bit] NULL,
	[CompanyID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PType_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PO_D]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PO_D](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[IID] [varchar](max) NULL,
	[CTN] [varchar](max) NULL,
	[PCS] [varchar](max) NULL,
	[SCH] [varchar](max) NULL,
	[Qty] [varchar](max) NULL,
	[PurPrice] [varchar](max) NULL,
	[PAmt] [varchar](max) NULL,
	[DisP] [varchar](max) NULL,
	[DisAmt] [varchar](max) NULL,
	[DisRs] [varchar](max) NULL,
	[Amt] [varchar](max) NULL,
	[SRT] [varchar](max) NULL,
	[RCancel] [varchar](max) NULL,
	[Pur_D_ID] [int] NULL,
	[UnitId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Pur_D]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pur_D](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[IID] [float] NULL,
	[BNID] [float] NULL,
	[ExpDT] [datetime] NULL,
	[CTN] [float] NULL,
	[PCS] [float] NULL,
	[SCH] [varchar](max) NULL,
	[Qty] [float] NULL,
	[PurPrice] [float] NULL,
	[PAmt] [float] NULL,
	[DisP] [float] NULL,
	[DisAmt] [float] NULL,
	[DisRs] [float] NULL,
	[Amt] [float] NULL,
	[SRT] [float] NULL,
	[RCancel] [float] NULL,
	[Pur_D_ID] [int] NULL,
	[Pur_D_UnitID] [int] NULL,
	[SAmt] [float] NULL,
	[SRate] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Pur_M]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pur_M](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[CompID] [float] NULL,
	[EDate] [datetime] NULL,
	[AC_Code] [float] NULL,
	[RID2] [varchar](max) NULL,
	[InvNo] [varchar](max) NULL,
	[InvDT] [varchar](max) NULL,
	[BiltyNo] [varchar](max) NULL,
	[SID] [float] NULL,
	[WID] [float] NULL,
	[Rem] [varchar](max) NULL,
	[DisAmt] [varchar](max) NULL,
	[Cartage] [varchar](max) NULL,
	[NetAmt] [float] NULL,
	[APost] [float] NULL,
	[Posted] [float] NULL,
	[RCancel] [float] NULL,
	[Create_User_ID] [float] NULL,
	[Create_Date] [datetime] NULL,
	[Edit_User_ID] [float] NULL,
	[Edit_Date] [datetime] NULL,
	[Del_User_ID] [varchar](max) NULL,
	[Del_Date] [varchar](max) NULL,
	[VehicalNo] [varchar](max) NULL,
	[VendorId] [int] NULL,
	[CityId] [int] NULL,
	[Rent] [float] NULL,
	[pashgi] [float] NULL,
	[Bharai_chahti_chunai_khata_kharcha] [float] NULL,
	[OfficeKhata] [float] NULL,
	[Karamat_amat_khata] [float] NULL,
	[gari_Office_kharcha] [float] NULL,
	[TotalAmount] [float] NULL,
	[VenInvNo] [varchar](max) NULL,
	[VenInvDate] [varchar](max) NULL,
	[InvType] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PurR_D]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PurR_D](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[IID] [float] NULL,
	[BNID] [float] NULL,
	[ExpDT] [datetime] NULL,
	[CTN] [float] NULL,
	[PCS] [float] NULL,
	[SCH] [float] NULL,
	[Qty1] [float] NULL,
	[Qty] [float] NULL,
	[PurPrice] [float] NULL,
	[PAmt] [float] NULL,
	[DisP] [float] NULL,
	[DisAmt] [float] NULL,
	[DisRs] [float] NULL,
	[Amt] [float] NULL,
	[SRT] [float] NULL,
	[RCancel] [float] NULL,
	[id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PurR_M]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PurR_M](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[CompID] [float] NULL,
	[EDate] [datetime] NULL,
	[AC_Code] [float] NULL,
	[RID2] [varchar](max) NULL,
	[InvDT] [varchar](max) NULL,
	[BiltyNo] [varchar](max) NULL,
	[SID] [float] NULL,
	[WID] [float] NULL,
	[NetAmt] [float] NULL,
	[Rem] [varchar](max) NULL,
	[APost] [float] NULL,
	[Posted] [float] NULL,
	[RCancel] [float] NULL,
	[Create_User_ID] [float] NULL,
	[Create_Date] [datetime] NULL,
	[Edit_User_ID] [float] NULL,
	[Edit_Date] [datetime] NULL,
	[Del_User_ID] [varchar](max) NULL,
	[Del_Date] [varchar](max) NULL,
	[invRNo] [varchar](max) NULL,
	[invNo] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PV_D]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PV_D](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[Narr] [varchar](max) NULL,
	[MOP_ID] [int] NULL,
	[AC_Code] [int] NULL,
	[InvNo] [varchar](max) NULL,
	[ChkNo] [varchar](max) NULL,
	[SlipNo] [varchar](max) NULL,
	[PreAmt] [float] NULL,
	[Amt] [float] NULL,
	[DisAmt] [float] NULL,
	[BalAmt] [float] NULL,
	[SRT] [float] NULL,
	[RCancel] [float] NULL,
	[ID] [int] NULL,
	[checkDate] [datetime] NULL,
	[isDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PV_M]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PV_M](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[CompID] [int] NULL,
	[EDate] [datetime] NULL,
	[AC_Code] [int] NULL,
	[SID] [int] NULL,
	[Rem] [varchar](max) NULL,
	[APost] [int] NULL,
	[Posted] [int] NULL,
	[RCancel] [int] NULL,
	[Create_User_ID] [int] NULL,
	[Create_Date] [datetime] NULL,
	[Edit_User_ID] [int] NULL,
	[Edit_Date] [datetime] NULL,
	[Del_User_ID] [int] NULL,
	[Del_Date] [datetime] NULL,
	[isDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RV_D]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RV_D](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[Narr] [varchar](max) NULL,
	[MOP_ID] [int] NULL,
	[AC_Code] [varchar](max) NULL,
	[InvNo] [int] NULL,
	[ChkNo] [int] NULL,
	[SlipNo] [int] NULL,
	[PreAmt] [float] NULL,
	[Amt] [float] NULL,
	[DisAmt] [float] NULL,
	[BalAmt] [float] NULL,
	[SRT] [float] NULL,
	[RCancel] [float] NULL,
	[ID] [int] NULL,
	[checkDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RV_M]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RV_M](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[CompID] [int] NULL,
	[EDate] [datetime] NULL,
	[AC_Code] [varchar](max) NULL,
	[SID] [int] NULL,
	[Rem] [varchar](max) NULL,
	[APost] [int] NULL,
	[Posted] [int] NULL,
	[RCancel] [int] NULL,
	[Create_User_ID] [int] NULL,
	[Create_Date] [datetime] NULL,
	[Edit_User_ID] [int] NULL,
	[Edit_Date] [datetime] NULL,
	[Del_User_ID] [int] NULL,
	[Del_Date] [int] NULL,
	[isDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sale_Pur_D_Pur]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sale_Pur_D_Pur](
	[Pur_ID] [int] IDENTITY(1,1) NOT NULL,
	[RID] [int] NULL,
	[VendorID] [int] NULL,
	[ItemID] [int] NULL,
	[UnitID] [int] NULL,
	[Quantity] [int] NULL,
	[Pur_Price] [decimal](20, 2) NULL,
	[Pur_Total] [decimal](20, 2) NULL,
	[Comm] [decimal](20, 2) NULL,
	[CvenID] [int] NULL,
	[Total] [decimal](20, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[Pur_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Sale_Pur_D_Sale]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sale_Pur_D_Sale](
	[Sale_ID] [int] IDENTITY(1,1) NOT NULL,
	[RID] [int] NULL,
	[CityID] [int] NULL,
	[VillageID] [int] NULL,
	[VendorID] [int] NULL,
	[PukhtaBikri] [decimal](20, 2) NULL,
	[LongerTadat] [int] NULL,
	[KhamBikri] [decimal](20, 2) NULL,
	[Phaliyan] [decimal](20, 2) NULL,
	[CustomerExpense] [decimal](20, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[Sale_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Sale_Pur_M]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sale_Pur_M](
	[RId] [int] IDENTITY(1,1) NOT NULL,
	[VehicalNo] [varchar](max) NULL,
	[Date] [datetime] NULL,
	[Rent] [decimal](20, 2) NULL,
	[pashgi] [decimal](20, 2) NULL,
	[bharai_chatai_kata_kharacha] [decimal](20, 2) NULL,
	[Office_khata] [decimal](20, 2) NULL,
	[CarAmad_AmadKharcha] [decimal](20, 2) NULL,
	[gari_OfficeKharcha] [decimal](20, 2) NULL,
	[Total_Purchase] [decimal](20, 2) NULL,
	[advanceBuilty] [decimal](20, 2) NULL,
	[OwnBuilty] [decimal](20, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[RId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sales_D]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sales_D](
	[SD_ID] [int] IDENTITY(1,1) NOT NULL,
	[RID] [float] NULL,
	[IID] [float] NULL,
	[BNID] [float] NULL,
	[ExpDT] [datetime] NULL,
	[CTN] [varchar](max) NULL,
	[PCS] [float] NULL,
	[SCH] [varchar](max) NULL,
	[Qty] [float] NULL,
	[PurPrice] [float] NULL,
	[SalesPriceP] [float] NULL,
	[AddPer] [varchar](max) NULL,
	[AddAmt] [varchar](max) NULL,
	[SalesPrice] [float] NULL,
	[PAmt] [float] NULL,
	[DisP] [varchar](max) NULL,
	[DisAmt] [varchar](max) NULL,
	[DisRs] [varchar](max) NULL,
	[Amt2] [float] NULL,
	[Amt] [float] NULL,
	[PCK_Det] [float] NULL,
	[SRT] [float] NULL,
	[RCancel] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[SD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sales_M]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sales_M](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[CompID] [float] NULL,
	[RID2] [varchar](max) NULL,
	[EDate] [datetime] NULL,
	[CAC_Code] [varchar](max) NULL,
	[AC_Code] [float] NULL,
	[Ship_To] [varchar](max) NULL,
	[Ship_ID] [varchar](max) NULL,
	[Trans_ID] [varchar](max) NULL,
	[BiltyNo] [varchar](max) NULL,
	[SID] [float] NULL,
	[WID] [float] NULL,
	[Rem] [varchar](max) NULL,
	[NetAmt2] [float] NULL,
	[DisAmt] [varchar](max) NULL,
	[PreBal] [float] NULL,
	[NetAmt] [float] NULL,
	[AC_Code3] [varchar](max) NULL,
	[CashAmt] [varchar](max) NULL,
	[APost] [float] NULL,
	[Posted] [float] NULL,
	[RCancel] [float] NULL,
	[War_Cls] [float] NULL,
	[Create_User_ID] [float] NULL,
	[Create_Date] [datetime] NULL,
	[Edit_User_ID] [float] NULL,
	[Edit_Date] [datetime] NULL,
	[Del_User_ID] [varchar](max) NULL,
	[Del_Date] [varchar](max) NULL,
	[InvNo] [varchar](max) NULL,
	[InvDT] [datetime] NULL,
	[InvType] [varchar](max) NULL,
	[CstId] [int] NULL,
	[TotalAmount] [decimal](20, 2) NULL,
	[CstInvNo] [varchar](max) NULL,
	[VenInvDate] [varchar](max) NULL,
	[TransportExpense] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sizes]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sizes](
	[SizeID] [int] IDENTITY(1,1) NOT NULL,
	[SizeName] [varchar](max) NULL,
	[BranchID] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](max) NULL,
	[ModifiedBy] [varchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
	[IID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[SizeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Styles]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Styles](
	[StyleID] [int] IDENTITY(1,1) NOT NULL,
	[StyleName] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](max) NULL,
	[ModifiedBy] [varchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[StyleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Table]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Table](
	[OrderId] [int] IDENTITY(1,1) NOT NULL,
	[KOTID] [varchar](max) NULL,
	[OrderNo] [varchar](max) NULL,
	[OrderDate] [datetime] NULL,
	[isComplete] [bit] NULL,
	[Discount] [decimal](20, 2) NULL,
	[Amount] [decimal](20, 2) NULL,
	[TblID] [int] NULL,
	[WaiterID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_city]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_city](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CityName] [varchar](max) NULL,
	[isDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_Employee]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Employee](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeName] [varchar](max) NULL,
	[PyteTypeID] [int] NULL,
	[isDeleted] [bit] NULL,
	[ACCode] [int] NULL,
	[companyID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_KOT]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_KOT](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[KotNo] [varchar](max) NULL,
	[OrderID] [varchar](max) NULL,
	[iscomplete] [bit] NULL,
	[CatID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_Opd]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Opd](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DoctorID] [int] NULL,
	[PatientID] [int] NULL,
	[fee] [decimal](20, 2) NULL,
	[discount] [decimal](20, 2) NULL,
	[TotalAmount] [decimal](20, 2) NULL,
	[ItemID] [int] NULL,
	[DateTime] [datetime] NULL,
	[PaymentMode] [int] NULL,
	[TokkenNo] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_OpeningCash]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_OpeningCash](
	[EntryDate] [datetime] NULL,
	[Amount] [float] NULL,
	[BankAccount] [float] NULL,
	[CashOpeningId] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_Order]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Order](
	[OrderId] [int] IDENTITY(1,1) NOT NULL,
	[KOTID] [varchar](max) NULL,
	[OrderNo] [varchar](max) NULL,
	[OrderDate] [datetime] NULL,
	[isComplete] [bit] NULL,
	[Discount] [decimal](20, 2) NULL,
	[Amount] [decimal](20, 2) NULL,
	[TblID] [int] NULL,
	[WaiterID] [int] NULL,
	[OrderType] [varchar](max) NULL,
	[GST] [decimal](20, 2) NULL,
	[userID] [int] NULL,
	[Cat] [varchar](max) NULL,
	[Address] [varchar](max) NULL,
	[ItemDetails] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_OrderDetails]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_OrderDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NULL,
	[KOTID] [varchar](max) NULL,
	[itemID] [int] NULL,
	[Qty] [decimal](20, 2) NULL,
	[Rate] [decimal](20, 2) NULL,
	[CatID] [int] NULL,
	[itemDtl] [varchar](max) NULL,
	[disc] [decimal](20, 2) NULL,
	[itemName] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_Receipe]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Receipe](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NULL,
	[qty] [decimal](20, 2) NULL,
	[Description] [varchar](max) NULL,
	[setup] [varchar](max) NULL,
	[RecipceItemId] [int] NULL,
	[isActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_Table]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Table](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [varchar](250) NULL,
	[isDeleted] [bit] NULL,
	[companyID] [int] NULL,
 CONSTRAINT [PK_tbl_Table] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_Village]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Village](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[VillageName] [varchar](max) NULL,
	[CityID] [int] NULL,
	[IsDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_Warehouse]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Warehouse](
	[WID] [int] IDENTITY(1,1) NOT NULL,
	[Warehouse] [varchar](max) NULL,
	[WSht] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[WID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblStock]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStock](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[BatchNO] [varchar](max) NULL,
	[Expiry] [datetime] NULL,
	[Quantity] [int] NULL,
	[Id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblWaiter]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblWaiter](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Vendors]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Vendors](
	[VID] [int] IDENTITY(1,1) NOT NULL,
	[VendName] [varchar](max) NULL,
	[PType_ID] [int] NULL,
	[Add] [varchar](max) NULL,
	[NTN_No] [varchar](max) NULL,
	[ContactPerson] [varchar](max) NULL,
	[Cell] [varchar](max) NULL,
	[Eml] [varchar](max) NULL,
	[Tel] [varchar](max) NULL,
	[ZID] [int] NULL,
	[Debit] [float] NULL,
	[Credit] [float] NULL,
	[AC_Code] [int] NULL,
	[InActive] [bit] NULL,
	[Land] [varchar](max) NULL,
	[City] [int] NULL,
	[Village] [int] NULL,
	[CompanyID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[VID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Zone]    Script Date: 11/8/2021 11:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Zone](
	[ZID] [int] IDENTITY(1,1) NOT NULL,
	[Zone1] [varchar](max) NULL,
	[is_Deleted] [bit] NULL,
	[CompanyID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ZID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName]) VALUES (N'1', N'abc@gmail.com', 1, N'admin', N'1', N'4546', 1, 1, CAST(N'1990-01-01 00:00:00.000' AS DateTime), 1, 1, N'admin')
SET IDENTITY_INSERT [dbo].[Items_Cat] ON 

INSERT [dbo].[Items_Cat] ([CatID], [Cat], [isDeleted], [CompanyID], [img], [Images]) VALUES (1, N'BBQ', 1, 0, N'No_Cover.jpg', N'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UzaC8ZKiRFRzRUY3R2MoVVZXGrLC0uLyZIN0k4Rlo7PD0+MpOGbzdSo5OkhJSlhZWmdoaWp2d3h5eoWGh4iJipSVlpeYmZqkpaanqKmqtLW2t7i5usTFxsfIycrU1dbX2Nna5OXm5+jp6vT19vf4+fr/xAAfAQAABgMBAQEAAAAAAAAAAAAGBQQDBwIIAQkACgv/xAC1EQACAQMCBAQDBQQEBAYGBW0BAgMRBCESBTEGACITQVEHMmEUcQhCgSORFVKhYhYzCbEkwdFDcvAX4YI0JZJTGGNE8aKyJjUZVDZFZCcKc4OTRnTC0uLyVWV1VjeEhaOzw9Pj8ykalKS0xNTk9JWltcXV5fUoR1dmOHaGlqa2xtbm9md3h5ent8fX5/dIWGh4iJiouMjY6Pg5SVlpeYmZqbnJ2en5KjpKWmp6ipqqusra6vr/3QAEAD//2gAMAwEAAhEDEQA/AN/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691/9Df49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvdf/R3+Pfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3X/0t/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691/9Pf49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvdf/U3+Pfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3X/1d/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691/9bf49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvdf/X3+Pfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3X/0N/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691/9Hf49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvdf/S3+Pfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3X/09/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691/9Tf49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvdf/V3+Pfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3X/1t/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691/9ff49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvdf/Q3+Pfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3X/0d/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691/9Lf49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvdf/T3+Pfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3X/1N/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3XvfuvdJTLb82PgJRBnd57UwsxeWIQ5bcWIxspkg0iaMR1lZC5eEuNQtdbi/19+61UDiR1xxW/8AYmdmNPg967SzNQHhjMGK3Hh8jMJKhilPGYqSsmfXO6kILXYiwv7916oPAjpW+/db697917r3v3Xuve/de697917r3v3Xuve/de6h12Rx+MhFRkq6jx9OziNZ66qgpITIVdxGJZ3jQuUjY2veyk/j37r3Dj0iR231SSAOzevSTwAN57cJJP0AH8S9+61qX+IdLijr6HIw/cY+spa6AO0Zno6iGph8igFk8kDumtQwuL3F/fut9Svfuvde9+691737r3XvfuvdYKmppqOCSpq6iClpogDLUVMscEEYLBQZJZWWNAWYDkjk+/de6RM/avV9NNLT1PZGwqeogkeKeCfeG3opoZY2KyRSxSZFXjkRgQVIBB+vv3WtS/xDpU4rOYTOw/cYTMYvMU/jhl8+KyFJkIfFUKzU8nlpJpk8c6oShvZgDa9vfuvAg8D06e/db697917r3v3Xuve/de697917r3v3Xuve/de697917r3v3Xuve/de697917r3v3Xuve/de697917r3v3Xuve/de697917r3v3Xuve/de697917r3v3Xuve/de697917r3v3Xuve/de697917r3v3Xuv/V3+Pfuvde9+691737r3Xvfuvde9+691737r3XvfuvdBh3Rt3Mbs6u3ltzb9H/ABDM5XFrT0FH9xS0v3EwrKWUp9xWz01LF+3Gxu7qOPrf37qrAlSBx6qZ3h0V2psHCybi3btb+E4eKop6WSs/je3K/TPVOUgT7fG5esqj5GFrhCB+SPfumCrAVI6CumqaijqaespJpKeqpZ4qmmqIXMc0FRBIssM0UikMkkUihlI5BHv3Verrukuy6ftTYGJ3EXjGYgX+F7kpU0r9vm6NEFTIIk4jp69GWpiA4WOULe6m3ulKtqFfPqP3/tXPb26k3btjbFB/E85k/wCA/Y0P3VFRef7Lc2GyFT/lOQqKSjj8dHSSP65FvpsLsQD7rzglSBx6qk3v0r2Z1xiafObz21/BsXVZGLFQVX8Z2/kfJXz01XVxQeHFZWuqF1U9DK2pkCDTYm5APuk5VlyR17ZHSvZnY+JqM5szbX8ZxdLkZcVPVfxnb+O8dfBTUlXLB4crlaGobTT10TalQodVgbgge68FZsgdWj/HHZm5dhdXY7bm7Mb/AArMwZTMVEtH95QV2iGqrGlgf7jG1VZSt5IzewckfkA+/dPoCFoePS57H7H211ftqp3LuWpKRITBj8fAUavy9eyM0VBQRMyh5HCksxISJAWYgD37qzMFFT1VP2b8i+x+yqieGXKz7b247EQ7bwVTNS0xiB9IydbH4qzMSNZSwlIg1qGSJD790nZ2b7OmPbfQncG7KZKzC7DzL0ssZlhqMkaLAwzxAxjyU8meq8YtQj+UaSmoOAStwrW914Kx4DrvcXQXcW1adqrMbBzQpo4xLLPjDRZ+KGI+W8k74CryawIgiJcvpCCxawZb+68VYcR049bfIPsjrWopY6LM1GbwELIku2s5UTVuPNKGXXFj5JWeoxEgQHQYGEYc3aNxdT7ryuy+eOrVere1Ns9s7cTPbflaKeAxwZnD1DL9/hq549f284Wwmp5dLGGdQEmUH9LK6L7p9WDCo6Ev37q3Xvfuvde9+691737r3RFO/PlbJtyurtmdZSUs+WpGkpcxuqSOOrp8bVxvplosNTyiSlq6yBlKyzSq8MbXVUZvUnumnkpheiHpHv8A7Sz50LuXfG4akjU3+XZmrjjeSwZ3PlWioYWb6kxwRL/qVHHumssfU9COPi/3saX7z+4NR4fAajQc5tcVXjEfk0/YnN/e+fT/ALq8fl1enTq49+63ob06D+Wn7H6mzkTyxbp2Jm0ZmhltX4eWqSFtDmKUeKHJURLlW0mWF1Yg3BIPutZU+h6U3ZXdW6O1sFtPGbsho58ntabLsM5SxrSy5WLKJjVH3tBDGlJFVU7Y83khEcbq4HjUqWb3W2YtSvVgXw3/AOZNx/8Ah0Z3/eqL37p2P4ejWe/dOdFK7++TNF1pLLtTaMdHmd6GP/LpZyZcZttZY9UX3SRMprMo6sGSn1KsakNIbWjf3TbvpwOPVcWUz/ZHbOcVchW7l3tm6hmenoII6rIGIA2YY/EUMRpaCnQyElYIY41LE2Fz790zUsfU9L6l+L/e1ZAlRFsGoSOTVpWqzu16GcaHZDrpa3OU9TFdlNtSDULEXBBPut6G9Og+zG1OxesshSVuWw+59m16yA4/KeOuxhMxTyWoMvSskUkyJywilLLYg2IPv3WqEeVOjU9L/LvM4qspNvdp1D5jCzOkEO6hFfL4otqCvlEgS2WoQSupwoqYxdiZuFHurrIRhuHRvO+9t5jsXp7OYXZdNDncjmv7vVmKjp6/H08FdSxZrF5FqiGuraqmoDCaGJpFYygOLabkgH3TjgsuOqp99dRdida0+Pqt67dfC02Vmnp6GYZPDZKOaemSOSWJmxGRr/A4jkBUSaNYB030tb3TBUrxHWDYnVm++yzkl2ThEzT4gUrZGP8Ai+DxslOtaZxTOI8vkqB5kkNM4LRhwpFmtcX914KW4Dq4rqPA5XbHWmytv5yl+xy+IwNHRZCk89NU/b1MQbyR/cUc1RSy6b/VHZT/AF9+6UqKKAes3amEye5Ot974DC033uWy+28rj8dSeanp/uKuppXjhi89XLBTRa3IGp3VR+SPfuvMKqQOqdN99S9gdaQ42fe+CTCR5eSpixwOZwORkqno1heq0Q4nKV0ypAKiPUzKqguovcge/dJipXiOsmxeoOxuyqSvrtlbcfM0mNqI6StnOTwuNjiqZYzMkKnL5KgM7+L1N49WkEarXF/deCluA6NJvzoPtnNdT9JbZxm0/uc3tCDf6biov47tqH+Htm87j6zGD7mozMVJV/c00DN+xJLotZ9JIHv3ThRtKimc9E53fszcuws3NtzdmN/hWZggp6iWj+8oK7RDVRiWB/uMbVVlK3kjN7ByR+QD7900QQaHj0vdr/H3t7eeCoNzba2j/EsJlFnehrf49tij8601VPRzH7avzVLVxaKmmdfXGt7XFwQT7qwRiKgY6f8A/ZVu+v8AnhP/AF6Nmf8A2Re/de8N/Tpuy/xr7rwWJyecyuy/tcXhsdW5XJVX949pz/bUGOppausn8NNnZqibw08LNpjRna1lBNh7917QwzToQvhh/wAzgqP/AAzs1/7m4j37rcfxdRewvjd3Tkt574z9FszzYiv3PuXMUlX/AHi2pH5cdVZWtrYKjwS52Opj8lNIG0MiyC9ioPHv3XijVJp0WDHY+ry2QocXj4vuK/JVlLj6KDyRRearrJ0p6aLyzPHDH5JpFGp2VRe5IHPv3VOh4/2Vbvr/AJ4T/wBejZn/ANkXv3VvDf06Ys1s3vLp2FK2vpd47No4qnSmRw+ZmXGxVdVAq2/iW38hPQRzVML6OZAXsyclWA914hl9R0bn41fJXM7pzFN192DUrX5SuWUbd3GY4KeeqmgiknbFZVIUhgkneCI+CdVV5GXQ+t3De/dOI5Joej4e/dO9e9+691737r3Xvfuvde9+691737r3Xvfuvde9+691/9bf49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3RXPmD/zJbI/9r/Af+5Te/dNyfD0TPqjqz/Sd032SuPg8u59s5rG5rb2hby1TJjKr+I4dP6/xWmiAQcXqI4rkAH37ptV1K3r1D+L/af+jjsGLHZSo8O2N3tT4bLGVykFBX+UriMs+plSNaaplMUrsQqQTux/QPfuvI2k/Lq3v37pR0Tn5u/8yp2//wCJCxX/ALze7Pfum5fhH29e+EX/ADKncH/iQsr/AO83tP37r0Xwn7ejje/dOdUy/IbtGo7O7CyVRBU+TbWAmqMNtmGNwYHpKeUpU5QaWKSS5epjMofg+DxIf0e/dJnbUfl0bj4t/H/FYzCYzsreOOir87lokr9t46uhSWmwuNks9FlGp5FaOTKV8dponN/BCyFbSFtPunI0xqPR4vfuneve/de6JZ8mvjxjNyYjJdgbMx8NDunFwz5DN4+iiEUO5KGFDLVzinjAQZumjVpA6ANVDUrapChHumnTFRx6I30t2bXdV77xW4I5pv4NPNHj9zUSFmjrcLUSKtS/hX/OVVBfzwWsfJGFvpZgfdNK2k16uzhmiqIYqiCRJoJ40mhmiYPHLFKoeOSN1JV0dGBBHBB9+6VdZPfuvde9+690Xj5Ndk1HXPWlY+LqHp9wbmn/ALv4ieJis1GKiGWXI5KJgQ0clJQxssbqdSTyxsPp791R2ovz6q16y6/y3Z+88VtLFN4mrZGnyNeyeRMZiqcq1fkZULx+QwxtZE1L5JWVLgtf37pgAsaDq53YmwNrdcYGn2/tXGxUNLEsZqqkqjZDK1SoEevylWqI9XVy/wBTZUHpRVQKo90pACig6Wnv3W+k/ubau3t5YipwW58RR5nFVQ/cpayPWEcAhJ6eVSs1JVRajoliZJEP0Ye/daIBFD1T93x0/U9P7vGNhlmrduZiKWv23kJwomemjkVKnH1ZQBGrsZJIiuygCRHR7LrKL7pOy6TTy6Pr8N/+ZNx/+HRnf96ovfunY/h6FPu3sVeruus3ueIxHLFY8Xt+GYKyTZvIB0pGaNyomjoo0kqZEvd4oGHv3VmbSCfPqnrau3Nwdm71x2BopJK3O7nyjtUV1UzylWmaSryeVrpOZHjpYFknlPLEKbXJAPuk4BJp59XMdadXbU6swEOE23RRicxxnKZmaKM5XM1Sj1VFbUBdfjDk+OEHxQqbKPqT7pQqhRjoRvfurdNmZwuJ3DjavDZzHUmVxddEYauhroEqKeeM/wCqjkBAdDYqwsyMAVIIB9+60QDg9VG/IrpF+o9yQ1OJ8s+zdxPUS4SWVmlmxtREVepwlXM12kanWQNBI51Sw/Us6SH37ph10n5dGQ+GPadTkaXJdX5qqaaTFUz5ja0k7lnGNEqR5PEK7HlKOeZJ4EF2CSS/RI1A91eNvwnowPyO2P8A376l3LRQReXJ4WIbnw4Chn+8wySyzxRr9TLWYt6iBQCPVIPr9D7qziqnquz4u74/uV23hI6ifw4rdQba+R1NaMSZF4zipmB9AMeXihUsbaI3fmxN/dMoaMOrh/fulPXvfuvdVGfLPfH97e16/F00wkxmy6ddu04QgxtkY3NRm5iLm0yV8n2zfTimHF7390nkNW+zqwj49bH/ALg9UbYxc8IhyeTp/wC8WZFgJP4jmkjqBDMAB+9Q0Agpm+vMP1I9+6eQUUdDX791bqo35ff8zsy//al2/wD+69Pfuk8nxHo+/wAYP+ZFbB/6hs3/AO9Pm/funY/gHQ9+/dX6QvaFJV5DrTsSgoKWora6t2Lu2koqKkhkqaurq6nAZCGnpaWnhV5qioqJnCIiAs7EAAk+/dab4T9nRCfiVsPfO2+1J8juLZm68DjztTL04rs1t3MYujNRLV4to4BU11HBCZpFjYqurUQpsOD790zGCGyOrH8x/wAWjKf9q6u/9xpffunzw6ox68/4/wD2N/4eO2f/AHdUXv3SUcR9vV7/AL90q6T27cRjc/tjP4bMRRTYzJYivpa1JVDIIZKaS8vNtLwEB0YWKsoIIIB9+60RUEdUbbLq6mg3jtOuomdKuj3LgqqlaP8AWtRBlKWWEqADdvIosLG/v3SUcR1fV790r697917r3v3Xuve/de697917r3v3Xuve/de697917r//19/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3XvfuvdFc+YP/Mlsj/2v8B/7lN7903J8PQafBf/AI93f/8A2usN/wC4NX791qLgegD+VnVR2Fvt9xYumMe2d6y1ORpxEloMfm9Qky2O9CLFDHLJKKiBePQ7KotGffuqSLQ18j0db4v9q/6RtgQY7J1Xm3TtBYMRlvK4NRXUKoVxGXa7vJIaimj8Uzt6mqIXY21C/unUao+Y6Rvzd/5lTt//AMSFiv8A3m92e/dal+Efb174Rf8AMqdwf+JCyv8A7ze0/fuvRfCft6MT2lmZNvdbb7zUDmOpx+089PSOpYFK3+G1EdE2pCrLaqdOQQR+PfurthT9nVKmyMIm5d57S27JfxZ3cuDxExF/TDkcnTUkzcEGyxSk/UfT37pKBUgdXyRRRQRRwQxpFDDGkUUUahI44o1CRxoqgBURQAAOAB790r6ye/de697917rxAIIIuDwQeQQfqCPfuvdUa9u7dp9p9nb42/RxrFRY/ceR+whUBVgoKqU1tDTqBxpgpKlEH9dP0H09+6SsKMR1bX0FmZs90317kKiR5Zht+HHSSSFmkkOFnqMMHdmuzuwoLljyx5/Pv3ShDVR0L/v3Vuve/de6rY+c2Xll3RsbA628NDgMhlxH9EMuVyIoy549TBMNYXvpF7Wub+6ZlOQOlP8ABjb9OKXfm6XQNVtUYvb9NIf1Q06Ry5GuRePpUSyU5PP+6h/sfdeiHE9WAe/dPde9+691737r3Xvfuvde9+691X586czIsHXm3o3Ihllz2Zqo7tpaSnTHUNA9gdJKrU1IuQSL8Wub+6Zl/COk58G9vwVW5N8bmljVpsNicViaRmW5Rs5U1lRUyRkn0useFVSbX0yEXsTf3Xohknqyb37p7r3v3Xuve/de6L98oNuU24ul92mWNWqcFHSbix8pUM1PPjaqP7l0vaxlxk1RFcH6Sfn6e/dUkFVPVa/x5zM2D7n6/qYZHQVediw0yqW0yw5yKbEtHIo4dL1gbngMoP1A9+6ZQ0ZerqSAQQRcHgg8gg/UEe/dKeqSO59ly9ado7kwVJrpqOmyK5bb8sf7RjxeQIyGNELoQdWPEngLC37kJIA9+6SsNLEdW5dTb1j7C672rusSI9VkcZFHlFTSPHmaEtQ5ZCgC+NTXU7sgsLxspHBB9+6UKaqD07b+3XTbG2XuXdtVoMeCxFVWxRubLUVgTxY+kvdfVWV8kcQ5HLj37rZNAT1UD03tWp7S7dwGPyeqtirszPuHck0oDLPRUTyZbJ/cekj/AHJSp4L2trnH49+6TqNTAdXW+/dKeve/de6qN+X3/M7Mv/2pdv8A/uvT37pPJ8R6F/pz5Vde9e9bbY2dmsNvOqyeFhyMdVPi8fhJqCQ1eYyOQjNPLV7ioqhwsNWobVElmBAuLE+6ssgVQCD0Jv8As7vVP/PP9hf+erbf/wBlnv3VvFX0PQudT97bR7iqc1S7Zx246GTBQUU9Wc7SYylSRK+SpjhFMcfl8mzsrUratQQAEWvzb3VlcNWnQ1e/dW6bsx/xaMp/2rq7/wBxpffuvHh1Q9tXKU+D3RtvN1aTSUuHz2HylTHTqj1D0+PyFPVzJAkskMbTNHCQoZ1Uta5A59+6SDBB6ss/2d3qn/nn+wv/AD1bb/8Ass9+6f8AFX0PQQdr/MZdz7dym2diYDI4hMzTz0FXnc1NTJXw4+oQRVEdDj6CWrhhqamJ2QytUP4lJKqWIZPdUaSooB0Fnxl6kzG/N94fcc9HLDtHaeTpctkMjNERTV2Qx0qVdDhqQuNFXNNUojTgXWKnvqILRq/utItSD5dW8e/dKOve/de697917r3v3Xuve/de697917r3v3Xuve/de6//0N/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3XvfuvdFc+YP/Mlsj/2v8B/7lN7903J8PQafBf/AI93f/8A2usN/wC4NX791qLgejP9wdc0faOwsztacRR17xiuwVZKoP2Gco1d6GbVyUin1NBMRz4Jntzb37q7DUCOqo+ot+5Tpfs2lyGRhqqampayfb+8MUQ3lOPNR9vkI3gVgJKvF1EQniW/MsIW9mPv3TCnS1ejvfNSpp6zqDa9ZSTR1NLVb7wlTTVELrJDPTz7Y3VLDNFIpKvHLGwZSOCDf37p2T4R9vWf4Rf8yp3B/wCJCyv/ALze0/fuvRfCft6H3uPGy5fqnsSgp1Z55dn56SCNAS8s1Lj56qKFAPq80kAUf4n37qzfC32dU49YZODDdkbBytUwWlx+8ttVdU5NglNDmKN55LkgDRECeeOPfuk4wQfn1ev790q697917r3v3Xuve/de6pK74y0Gb7h7Cr6aVZoP7x1VFHKltDjFpFiyyFeGQtRmx/tDn8+/dJWNWPVo/wAcKGXH9I9fQTAq8mJqa4Agg+LJ5bIZKA2YA2aCrUg/Qg3Fxz790+nwjobvfur9e9+691WT846OVN+bPyB/zNTtFqOPj/dtDmchNNz+fRkE9+6Yl+IfZ0JfwZykEm2t94UOPuqPO4zKNGbA+DJUD0kbr+WAkxTA/wCp4/qPfurRHBHR6/funeve/de697917pPbj3ZtvaNPQ1e58zQ4OkyOSgxFJV5GYU9LJkKmKeeGCSoYeGnDxUznXIyRjTywuL+60SBxPT9HJHLGksTpLFKiyRyRsrxyRuoZHR1JV0dSCCDYj37rfVefzqxsoqeucwqs0DwbjxsrgHTFLHJiKqBWP01TpLIV/wCWZ9+6Zl/D1x+CmTgSr7Hw7MBU1FNtrJwLfl4KKXM0tU1r3tHJXw/8lf63v3XovxDqxH37p7r3v3Xuve/de6BT5F5aDD9Lb/nnlWP7vDfwmEGxaWfL1VPjkiRT+piKgk25Cgn8e/dVc0U9VZdFUMuQ7i63ghBZ492YquIAJPixk4yU5soJssFIxJ+gAubDn37pOvxL9vV3Hv3Srohnzd2P91idsdhUkV5sXUNtvMOqgsaCuMlZippG4Ijpa1Jo/wA3aqX37pqUcD01fCDfP/H1dd1c/wDqN04WN2/5YY/Nwxlv+qWRUB/46Nb9R9+61EeI6UPzb3x9htzbuwKSa1Rn6s5zLop9QxWKbxUEMoJt4q3JuZFsCdVH9R+fdblOAOofwi2P9ridz9hVcVpspULtvDuygMKChMdZlZo25Jjqq14Y/wAWalb37r0Q4no+fv3TvXvfuvdVG/L7/mdmX/7Uu3//AHXp790nk+I9C/058VevewuttsbxzWZ3nS5PNQ5GSqgxeQwkNBGaTMZHHxiniq9u1tQgaGkUtqle7EkWFgPdWWMMoJJ6E3/ZIuqf+eg7C/8APrtv/wCxP37q3hL6noXOp+ido9O1Oaqts5HcddJnYKKCrGdq8ZVJGlBJUyQmmGPxGMZGZqptWouCALW5v7qyoFrToavfurdN2Y/4tGU/7V1d/wC40vv3Xjw6oe2ri6fObo23hKt5o6XMZ7D4upkp2RKhKfIZCnpJngeWOaNZljmJUsjKGtcEce/dJBkgdWI7l+E2x4dv5mba+b3nPuKHG1c2Fp8pksFJj6nIxQtJS01WtPtykmENTIoQssildV/xY+6eMQoaE16Ir1fW7ZwnYm3JN+4anyW3I8maDO0OTSVYqSOqSWhNbUw64yRiaiVZ5I3DArERp1Wt7ppaAivDq8CgoqDHUdNRYukpKHH00Sx0lJQQQ0tHBD9VSmp6dEgii5uAoA59+6VfZ1L9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3X/9Hf49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3RXPmD/zJbI/9r/Af+5Te/dNyfD0GnwX/wCPd3//ANrrDf8AuDV+/dai4Ho93v3TvVafzL6rOIzdH2diKe2N3A8WN3GkSDTS52KFvs69gv6Y8rRw6GNrCaC7EtKB790xItDqHQJZftJtx9BYnrrKztJl9o77xVXh3kOp6nbMmC3RF4r8sTh62oWLngQzRKOF9+6rqqmn59HT+EX/ADKncH/iQsr/AO83tP37p2L4T9vRw5Y45o5IZUWSKVHjljcBkkjdSro6m4ZWUkEH6j37pzqjbtbYtV1xv7ce1J45Fp6GvllxEzhyKvCVbGoxVSrtfyM1I6rJYsFmR1uSp9+6SsNJI6tK+O3b9H2jsqkhq6pBvDbtNTY/cVJI/wC/VCJBDTZ2IMxaWDJol5CP0VAdSAugt7p9G1D59GC9+6v1737r3QGd9dwY3qfZ1XNFUxPu3MU1RSbXxoZWm+6dDG2XqIvUVx+L1+RiRaWQLECCxK+6o7aR8+qj9nbWzHYO78PtnG+WpyefySQyVEhaZoY5HM2QyVU7sGeOjplknlJOpghtckX90nAJNPPq9LD4ukweJxeFoEMdDiMdRYuiQ2ulJj6aKkp0NgBdYYgOAB790rAoKdOPv3Xuve/de6KN8xNgz7p67pdzY+Az5DY1ZPXzqgLSHA5GOKDLsgHJ+2lp6adz9Fhic+/dNyCor6dEX6A7VHU+/abL1xmbbmVgOI3HFChldKGaRJIchFCoLST42pRZLKC7ReRF5f37ppG0mvl1crj8hQ5WipcljKunr8fXQR1VHW0kqT01TTzKHimgmjLJJG6m4IPv3Snj1M9+691xZlRWd2VERSzuxCqqqLszMbBVUC5J+nv3XuqoPlX3FR9ibopNt7dqVqtr7RepjFbCwaDMZubTHW1tO44loqOOMQQOPS58jqWR0Pv3SeRtRoOHRrPhxhNw4/rGfK5quyMtDncrJLt3G1lRPLT0GJoFNI1RRQTOwpEyFd5SVQKrpEji4a/v3TkYOnpX/J3YM2/eqcsmPgNRmdszR7mxcUas00/2Ec0eSpYwl3kebFVEzJGAfJMiC17Ee624qvz6rK6Y7Im6r7AxG6dEk+NtLjM9SQ/5yqwlcYxVrGupA89LJFHURKSFaWFQSAT790wraTXq6rEZfG57GUOZw1bBkcXk6aKsoa2mfXDU08yho5ENgwNjYqQGVgQQCCPfulQNcjpx9+691737r3VZPy87lot1ZGk662zWrVYfb9Y9ZuGuppQ9NX52NXggoIXjOmanxEcknka7K9RJawMIJ90xI1TQcOsnws6+qclurJ9i1cDJjNuUtRicTMyi1Rm8nAI6swsbkigxMrLJwOapLHhh7916IZr1Zl790/0i+xdoU+/Nj7m2jUaAM3iqimppHAK0+QQCoxlUQQbilyMMUn+On37rTCoI6pv6w3XV9Ydm7ez9UstL/A80aLO05B8i46ZpMZnKaSNQweWKllkKixtKikcgH37pMp0sD0/967xfsztzP5DGMa+iFdBtvbiwHyrU0WOf7GmelIJ1pk60yVCW+vn9+625qxPVuPXW0KfYex9s7Rp9BGExVPTVMiABajIODUZOqAAFhVZGaWT/AA1e/dKFFAB0tPfut9e9+691Ub8vv+Z2Zf8A7Uu3/wD3Xp790nk+I9H3+MH/ADIrYP8A1DZv/wB6fN+/dOx/AOh79+6v0lt85yr2zsneO5KCOnmrtv7W3BnKKKrSSSklq8Tiauvp46qOGWnmeneanAcJIjFSbMDyPdaJoCein/H35I757X35LtfcWK2pRY9MDkMoJsLQ5inrPuKSooIo0MldncjD4WWqbUPHqJAsRzf3TaOWND0cjMf8WjKf9q6u/wDcaX37p08OqMevP+P/ANjf+Hjtn/3dUXv3SUcR9vV7/v3Srqpj5a9bnZvY0m4qCmEWC3wsuWiMa2hgzkZRc5TcLZXqJ5Fq/ryahgOF490nkWjV8j0dH4sdkLvzrSjxtbUGXP7L8GByQkfVNPQJG38DyDXLOyz0MRhZmOp5qeRj9R7907G1V+Y6Mt791fr3v3Xuve/de697917r3v3Xuve/de697917r3v3Xuv/0t/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3SK7F3h/cDZO4d4/wAO/i38BolrP4d939h93eogg8f3f2tZ4Lea9/E/0tb37rTGgJ6rb7h+U3+ljZVRs/8AuL/APuK/H138R/vP/FdH2Mpl8X2n93sdq8t7avKNP9D790wz6hSnSZ6L+Qn+hbHbgx/90f7y/wAdraKs8v8AH/4N9r9pBND4/H/Bcr5/J5b31Ja1rH37ryPprjqyXpjtL/S9s+Tdf8C/u9ozFbifsP4n/Fr/AGcNJN9x91/D8ZbyfdW0ePjT9Tfj3TytqFadLPee08Xvna2c2nmYw+PzdBLRyPpDPTTG0lJXQgkD7igq40mjuba4xfj37rZFQQeqON27Xyuy9y5rauai8OTwldLRVIF9EoWzwVUJNi1NWUzpNE39qN1P59+6SkUJB6so+EX/ADKncH/iQsr/AO83tP37p+L4T9vRxvfunOi8/IDoqi7gwkFTQSU+O3nhIZVw2RmBWnraZ2Mr4bJyIjyikklJaKQBjTysSAVdw3uqOmr7eqsJId/9P7uUuuX2buzEOWie3ilMb6kLxP8AuUeSxtWgIJHlp50uDqF/fumMqfQ9Gm2384d20FNHBujZ2H3FNHGU+8x2RqNuzzOPHomqI2os1Sl7B9YijiUlhYKFIb3VxKfMdc9xfOPddbTPDtjZWGwE7x6Pu8nk6ncMkTHXqlgiio8HAHAK6RIsigg3DA2HuvGU+Q6KpLLv7t3doZzmd57ty7hVCIaicxofoscax0uOxtIHJNhFTU6XJ0qCffuqZY+p6tB+PPQVL1JjJcxmmp6/fOYp1irqmH9ymw1CxjlOHx8p5lZpUVqiYACR1VVGhAz+6fRNOTx6Mt791fr3v3Xuve/de6xzQw1MMtPURRz088bwzwTIssM0MqlJYpYnDJJHIjEMpBBBsffuvdVRfIH43Znr3IV+59pUVRlNhVDy1brTq9RV7V1HXLS5BAGlfFRknw1XIRBomIYB5fdJ3QrkcOg56w777C6pH2eCr4MhgXdpJNuZuOWsxaySPrkmovHNT1eOncsxPhlSN3bVIjkC3utK5Xhw6MtH87awUoSXrKmet8bA1Ee7pYqUzEHQ4o225NKI1Nrp57m36hfj3V/F/o9AL2b8l+x+y6SfDzVFLtvblQrR1OGwKzQ/xCJrgx5TITyy1tXGVYhokaKncW1RkgH37qjOzfZ09dFfG/cPZVfQ53cVJV4TYMbx1EtZOr01ZuGJSHFJhY2CytTVH6XrLCJVJ8ZdwQPdbRC2Tw6tmoKCjxdDR4zHU0VHj8fS09FQ0kCCOClpKWJIKenhQcJHDEgVR+APfulHUv37r3VaXyI+MOUxOQyG+OucbJkcDWSS1uY23QRa63BzuWlqKnF0kS6qrDu12MUYMlMTYKYheP3TDpTK8Oi+dZd49g9Tu8G3cjFUYeWZpqnbuYiesxEk7AK88cSSwVVDUOFAZ4JYi9hr1WAHuqKxXh0aCl+dtUkCLW9Y09RUjV5ZqXd8lHA93Ypop5dtV0kemMgG8rXIJ4BsPdOeL/R6B/sP5Y9l74oZ8RQGi2dialDFVJgjUHKVcLpplgny9RIZooZL8inSnYr6WZlJB91VpGOPLpGdP9Fbv7byULUdNNitqwzhMpumqgcUUSof3qbGq5jGUyQXjxxnTGSDKyAgn3WlUt9nVwG0tqYPZG3cXtfbtIKPE4mnEFPHcPLIzM0k9VUy2UzVdXO7SSvYanYmwFgPdKAABQdKP37rfXvfuvdVGfLPY/8AdLtevylNCI8ZvSnXcVOUAEa5GRzT5uEmwvM9fH9y314qRze9vdJ5BRvt6jfFPY/98O2sVW1MXkxmzom3PVllBRqyldIsLFqNwJRlJY5wLG6wN9PqPdejFWHVvnv3Sjr3v3Xui998d8f6E/7q/wC/V/vN/eb+Of8AL8/g32X8G/g//Vny33P3P8W/5t6PH/a1ce6o76aY6rC7f7I/0rb2q94/wb+A/dUWPo/4d/Ef4p4/sKcQeT7v7HHavLa9vENP0uffumGbUa06HvrD5cf6N9iYDZX+j/8AjP8AA466P+J/3r/h33X3mTrclf7P+7Vd4PH95o/zr3034vYe6usmkAU6X3+z3/8Afq//AF+P/wAz/fut+L/R6T27vmj/AHp2pufbH+jb7D+8e3s1gfvv74/dfZ/xfG1OP+6+2/urT/cfb/ca/H5I9dralvce68ZKgjT0jfhh/wAzgqP/AAzs1/7m4j37qsfxdDPvT5m/wbNbs2n/AKN/uf4VlM7t3+If3w8P3H2NXVY37z7X+60vi8vi1+PyNpvbUfr791cycRp6r727lv4BuDBZ37f7v+C5jGZb7Xy+D7n+HVsFZ9v5/HN4fN4dOvQ+m97H6e/dMjBB6s/6g+VH+lbe1Js7+4n8B+6oshWfxH+8/wDFPH9hTmfx/af3ex2ry2tfyjT9bH37p9ZNRpToUO/uuR2X1pm8PS06zZ3HJ/HNuHTeU5XHo7/aRGxOrJ0jS0wHC6pVJ/T791Z11KfXqrbpntrJdN7smz9PjmzFHV4+pxeVwb1z4xaxGZZaaT7n7SuWCooqyJWDGFzoLoNOssPdMK2k16sl6K+QH+mqr3HS/wB0v7tf3fpsbUeT+Pfxn7v+IS1kejT/AAbFeDw/aXvd9Wr6C3PunkfVXHRjffur9e9+691737r3Xvfuvde9+691737r3Xvfuvdf/9Pf49+691737r3Xvfuvde9+691737r3Xvfuvde9+690y7j27h92YTI7c3BR/wAQw2VgFPX0f3FVS/cQiRJQn3FFPTVUX7kam6Op4+tvfutEAih4dAr/ALKt0L/zwn/r0bz/APsi9+6r4aenXv8AZVuhf+eE/wDXo3n/APZF7917w09OhX2XsXavXuHbAbPxf8IxLVk9e1J99kcherqEhjml8+Uq62pGtIEGnXpFuALn37qwAXA6Vvv3W+gD7Q+OWwe2M7Tbiz9TuDGZSCgjx0s236vGUi10EMkklO9alfiMn5Z4BKUV1KHRZTcKtvdUZAxqell1Z1Zt/qLb9ZtvbdZma2hrczUZyWXOVFFU1a1dTRY+gkjjkoMfjYRTiHGxkAxltRb1EEAe62qhRQdCV791br3v3Xuk3ubZ+1t50Ixu6sBi89RozPDFkqSKoamkYANLSTMvno5mVQC8TIxHF7e/daIB4jouuX+GvTmSkD0a7q2+od38OIzkc0ZVgoWInPUGbm0R2On16uTcni3uqeGvXHE/DPp3HSmSsbdmeQvC4gy2cghiVYi5eIHBY3Cz6KgMA93LAKNBU3J917w1+fRh9q7I2jseh/h20tvYvA0rBfN9hSpHUVRS+l66tbXWV8qg2DzSSMBxewHv3VwAOA6VPv3W+ve/de697917r3v3Xuve/de68QCCCLg8EHkEH6gj37r3QF7r+N3Tm76p66u2jT42vll8s1Vt+oqMJ52YHyGakoZI8dI8zep3MPlZ+dVy1/dUKKfLoLR8IuqAQf4/2Ef8DltuWP8AgbbUB59+614S+p6FPanxv6c2hUpW0O0KbI18Uomhq9wT1GcMLqP2zDS18kmOieFjqRxCJA1jquq291sIo8uhzAAAAFgOABwAB9AB791fr3v3Xuve/de697917oJN69F9Wb/mmrNw7SoTlJ28kuYxjTYfKSzG4M1VU46Sn+/lIa16hZha39Bb3VSiniOgan+E3U000sseY35SpI7OlNBl8G0MCk3EUTVW2qmoKJ9Brkdv6k+/dV8JfU9LfbPxY6X21NBUnbUu4aqnWDRNuavnycLvCtnlnxifbYaoapb1OslM0d+FVVuPfutiNR5dGDp6enpIIaWkghpaanjWKCnp4khggiQBUihhjVY440UWCqAAPfur9Zvfuvde9+691737r3SB331hsXsuHGwb3wKZuPESVMuOJr8rjpKV6xYUqtE2JrqGZknFPHqVmZSUU2uAffutFQ3EdcdidW7D6zTJJsjAJhBmGpXyTDIZXIyVRohOKUNLlq+vljSD7qSyoyrdybX9+68FC8B0IHv3W+ve/de6D3fnVWwuzf4V/ffA/wAb/gn338M/3KZnG/bfxL7P73/i0ZGg83m+wh/zmvTo9Nrtf3WiobiOg9/2VboX/nhP/Xo3n/8AZF791Xw09Ovf7Kt0L/zwn/r0bz/+yL37r3hp6de/2VboX/nhP/Xo3n/9kXv3XvDT069/sq3Qv/PCf+vRvP8A+yL37r3hp6dK3ZfSHV/XuYbP7P2x/CMs9HPj2q/41uHIXpKh4ZJovBlMtW0w1vTodWjULcEXPv3Wwqg1A6YMp8aOks1k8jmMlsr7nI5auq8lkKj+8e7YfuK2uqJKqqm8NPnooIvLPKzaUVUW9gALD37rWhfTqD/sq3Qv/PCf+vRvP/7IvfuveGnp0qNodE9VbCzcO49p7V/hWZggqKeKs/jm467RDVRmKdPt8lmKylbyRm1yhI/BB9+62EUGoGehc9+6t0BOU+NHSOZyVflshseOWvydZU19bJDn900cUlVVzPPUSR0lFnKekp1eWQkJFGiLewAHHv3VNCny6WGxOpevutJslPsnb/8ABZcvHTQ5B/4rm8l9xHSNM9OunLZKvWLxtUOboFJvzewt7rYULwHQje/dW697917r3v3Xuve/de697917r3v3Xuve/de6/9Tf49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvdf/V3+Pfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3X/1t/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691/9ff49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3XvfuvdV9fJz/Tj/AKSIf9Hf+lf+Af3bxev+5f8Ae/8Ag/8AEPusl9zq/gf+RfeePx67+vTpvxb37pl9WrFadFDi7K7nnyEeJg3/ANnzZWWsXHxYyLdW65MhJXvMKdKGOiSvNS9Y1QdAiCly/ptfj37pvU3qesuJ7D7tz9fDi8FvntTNZOoErU+OxO5t25GvnEMTzzGGko62aolEUMbO2lTpVSTwD7916rHgT0f34m/6U/tt9f6Tf9IHk8+3f4N/fv8AvHr0ePNff/wz+8Hq06vD5vFxfRq/s+/dPR6s6q9Qvll/pZ+42L/oy/0iePw7j/jP9xP7y6NevCfYfxP+7/Gq3m8Pl5tr0/2vfutSasaa9EOy3YndmBr58VnN9dp4bKU3iNTjctufduOr6cTwx1EJno6yuhqIvNBKrrqUakYEcEH37pqrDiT0J3WOT+RGZ3XsTJvkO6MrtSr3Rt6SryDVe+K7b1ViVzVLHkHqasyS42bHCBJFmLMYtAYNwD791YayRxp1bf790o6Kb8rv9J38F2f/AKM/79/d/wAUyf8AFf7i/wB4PuftvtKf7f8AiH8A/d8Hl1aPJ6dV7c39+6bk1Y016ryynY3dWDr6jF5rffaOIydIYxVY7Kbo3Zj6+mMsSTxCoo6u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T/16N5//AGRe/de8NPToRtidYbG60hyNPsnB/wAFiy0tNNkE/iWYyX3ElIsyU7astkK9ovGs7iyFQb83sPfurBQvAdL737rfQC13xj6OyVbWZGt2R5qyvqqitq5v7y7vj8tTVSvPPJ44s/HFH5JZCbKoUXsAB791TQvp1F/2VboX/nhP/Xo3n/8AZF7917w09Opi/GXpBMfNi12TagqKymyE0H95N3HXV0cFXT08vlOfMy+OGulGkMFOq5BIBHuvaF9Oof8Asq3Qv/PCf+vRvP8A+yL37r3hp6de/wBlW6F/54T/ANejef8A9kXv3XvDT06d8V8ceksM+uk69xEzeWKa2VqMpnU1wm6L483kMhH4if1R28bjhgR791vQvp0MdDQUOMpIKDG0dLj6GmTx01FQ08NJSU8dy2iCngSOGJNTE2UAXPv3VuHTRurauB3tga/bG56D+J4PJ/a/fUP3VbRef7Ktp8hTf5Tj6ikrI/HWUkb+iRb6bG6kg+60QCKHh0Dn+yrdC/8APCf+vRvP/wCyL37qvhp6de/2VboX/nhP/Xo3n/8AZF7917w09Ovf7Kt0L/zwn/r0bz/+yL37r3hp6de/2VboX/nhP/Xo3n/9kXv3XvDT06WmQ6Y61ymzMP19Xbb8+0MDXHJYnEfxjPxfaVrHJEzffw5SPJz3OXqPTJM6fufT0rp91vStKUx0i/8AZVuhf+eE/wDXo3n/APZF791rw09Ovf7Kt0L/AM8J/wCvRvP/AOyL37r3hp6de/2VboX/AJ4T/wBejef/ANkXv3XvDT069/sq3Qv/ADwn/r0bz/8Asi9+694aenSo2h0T1VsLNw7j2ntX+FZmCCop4qz+ObjrtENVGYp0+3yWYrKVvJGbXKEj8EH37rYRQagZ6Fz37q3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvdf/9bf49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvdf/X3+Pfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3X/0N/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691/9Hf49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvdf/S3+Pfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3X/09/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691/9Tf49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvdf/V3+Pfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3X/1t/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691/9ff49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvdf/Q3+Pfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3X/0d/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691/9Lf49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvdf/T3+Pfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3X/1N/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691/9Xf49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvdf/W3+Pfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3X/19/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691/9Df49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvdf/R3+Pfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3X/0t/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691/9Pf49+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvdf/U3+Pfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3X/1d/j37r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691737r3Xvfuvde9+691/9k=')
SET IDENTITY_INSERT [dbo].[Items_Cat] OFF
SET IDENTITY_INSERT [dbo].[tbl_Table] ON 

INSERT [dbo].[tbl_Table] ([ID], [TableName], [isDeleted], [companyID]) VALUES (1001, N'table1', 0, 0)
SET IDENTITY_INSERT [dbo].[tbl_Table] OFF
USE [master]
GO
ALTER DATABASE [SaleManagerShahzaibold] SET  READ_WRITE 
GO
