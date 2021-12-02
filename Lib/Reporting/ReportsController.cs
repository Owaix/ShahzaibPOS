using Lib.Utilities;
using System;
using System.Data;
using System.Data.SqlClient;

namespace Lib.Reporting
{
    public class ReportsController
    {

        private const String Report_TestReports = "Report_TestReports";

        private const String Report_TestReportByDepartment = "Report_TestReportByDepartment";

        private String Report_BookingSummary = "";

        private const String Report_BookingSummary_Summary = "Report_BookingSummary_Summary";

        private const String Report_MonthlySummary = "Report_MonthlySummary";

        private const String Report_MonthlySummary_Summary = "Report_MonthlySummary_Summary";

        private const String BookingSummary_ReportCount = "BookingSummary_ReportCount";

        private const String Report_FreePatients = "Report_FreePatients";

        private const String Report_Receipt = "Report_Receipt";

        private const String Report_TestReport_Count = "Report_TestReport_Count";

        private const String Report_DiscountPatients = "Report_DiscountPatients";

        private const String TestWiseDetailSummary = "TestWiseDetailSummary ";

        private const String TestWiseDetailSummary_Count = "TestWiseDetailSummary_Count ";

        private const String TestWiseShortSummary = "TestWiseShortSummary ";

        private const String BookingSummary_UserTotalAmount = "BookingSummary_UserTotalAmount ";

        private const String Select_PatientReportRecord = "Select_PatientReportRecord ";

        private const String PatientReportDetails_Delete = "PatientReportDetails_Delete";

        private const String SelectAllTestResult = "SelectAllTestResult";

        private const String TestRateList = "TestRateList";

        private const String Select_WidalReport = "Select_WidalReport";

        private const String Select_PatientDetails = "Select_PatientDetails";

        private const String Select_BookedTestByname = "Select_BookedTestByname";

        private const String Report_SpecialChemistry = "Report_SpecialChemistry";

        private const String SelectAllDepartmentTest = "SelectAllDepartmentTest";

        private const String GetPatientInformation = "GetPatientInformation";

        private const String Report_TestWisePendingReport = "Report_TestWisePendingReport";
        private const String Report_CategoryandLabWiseTest = "Report_CategoryandLabWiseTest";

      

        public static DataTable GetItemSummary(int Item, DateTime reportStartDate, DateTime reportEndDate, int CompanyID)
        {
            var _query = @"Select OrderNo , OrderDate , IName, Items.IID , SUM(Qty) as Qty , SUM(Rate) as Rate from tbl_Order 
              left join tbl_KOT on tbl_KOT.Id = tbl_Order.KOTID 
              left join tbl_OrderDetails on tbl_OrderDetails.OrderId = tbl_Order.OrderId 
              left join Items on Items.IID = tbl_OrderDetails.itemID 
              WHERE ('0' = @Item OR Items.IID LIKE @Item) 
              AND tbl_Order.OrderDate BETWEEN @reportStartDate AND @reportEndDate And tbl_Order.CompanyID = @CompanyID
              group by IName , OrderNo , OrderDate ,Items.IID 
              order by OrderNo ";

            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(_query, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.Text;
            sqlCmd.Parameters.AddWithValue("@Item", Item);
            sqlCmd.Parameters.AddWithValue("@reportStartDate", reportStartDate);
            sqlCmd.Parameters.AddWithValue("@reportEndDate", reportEndDate);
            sqlCmd.Parameters.AddWithValue("@CompanyID", CompanyID);
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            return dt;
        }
        public static DataTable sp_getArticle(int companyID)
        {
            var _query = @"select ArticleTypes.ArticleTypeID,Styles.StyleID,Styles.StyleName,ArticleTypes.ArticleTypeName,
                           Article.ArticleNo,Article.ProductName,Article.IsDelete,Article.ProductID
                          from Article left join  ArticleTypes on Article.ArticleTypeID=ArticleTypes.ArticleTypeID
                          left join Styles on Styles.StyleID = Article.StyleID
	                      where Article.CompanyID=@companyID";

            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(_query, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.Text;
            sqlCmd.Parameters.AddWithValue("@companyID", companyID);

            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            return dt;
        }

        public static DataTable sp_PV_M_Insert(int companyID, DateTime Date, int AcCode, bool value)
        {
            string query = @"insert into PV_M (CompID,EDate,AC_Code,isDeleted) values (@CompID,@EDate,@AC_Code,@IsDelete)

	                      SELECT SCOPE_IDENTITY()";
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(query, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.Text;
            sqlCmd.Parameters.AddWithValue("@CompID", companyID);
            sqlCmd.Parameters.AddWithValue("@EDate", Date);
            sqlCmd.Parameters.AddWithValue("@AC_Code", AcCode);
            sqlCmd.Parameters.AddWithValue("@IsDelete", Convert.ToBoolean(value));
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            return dt;



        }


        public static DataTable sp_RV_M_Insert(int companyID, DateTime Date, int AcCode, bool value)
        {
            string query = @"insert into RV_M (CompID,EDate,AC_Code,isDeleted ) values (@CompID,@EDate,@AC_Code,'false' ) 
	                             SELECT SCOPE_IDENTITY()";
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(query, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.Text;
            sqlCmd.Parameters.AddWithValue("@CompID", companyID);
            sqlCmd.Parameters.AddWithValue("@EDate", Date);
            sqlCmd.Parameters.AddWithValue("@AC_Code", AcCode);
            sqlCmd.Parameters.AddWithValue("@IsDelete", Convert.ToBoolean(value));
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            return dt;



        }


        public static DataTable sp_RV_M_Update(int companyID, DateTime Date, int AcCode, int id)
        {
            string query = @"update RV_M set CompID=@CompID,EDate=@EDate,AC_Code =@AC_Code  where RID= @Id";
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(query, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.Text;
            sqlCmd.Parameters.AddWithValue("@CompID", companyID);
            sqlCmd.Parameters.AddWithValue("@EDate", Date);
            sqlCmd.Parameters.AddWithValue("@AC_Code", AcCode);
            sqlCmd.Parameters.AddWithValue("@Id", AcCode);

            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            return dt;
        }


        public static DataTable RecivedVoucharIndex(DateTime StartDate, DateTime EndDate , int CompanyID)
        {
            string query = @"select m.*,c.Amt,rvm.AC_Title as customer,d.AC_Title as cashBAnk,c.BalAmt,c.checkDate,c.ChkNo,c.DisAmt,
                             c.InvNo,c.MOP_ID,c.Narr,c.PreAmt,c.SlipNo,c.SRT,c.AC_Code as RV_TransactionCode,c.ID from RV_M as m
                             inner join RV_d as c on m.RID=c.RID
                             inner join COA_D as d on d.AC_Code=c.AC_Code
                             inner join COA_D rvm on rvm.AC_Code=m.AC_Code
                             inner join AspNetUsers Aspuser on Aspuser.AccessFailedCount=m.CompID
                             where (CAST(m.EDate as Date) >= CAST(@StartDate as Date) and CAST(m.EDate as Date) <= CAST(@EndDate as Date)) 
                             AND m.CompID = @CompID";

            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(query, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.Text;
            sqlCmd.Parameters.AddWithValue("@StartDate", StartDate);
            sqlCmd.Parameters.AddWithValue("@EndDate", EndDate);
            sqlCmd.Parameters.AddWithValue("@CompID", CompanyID); 

            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            return dt;
        }


        public static DataTable sp_RV_D_Update(String Narr, int MOP_ID, int AC_Code, int InvNo, int ChkNo, int SlipNo, Double PreAmt, Double Amt, double DisAmt, Double BalAmt, DateTime checkDate, int id)
        {
            string query = @"update RV_D set Narr =@Narr,MOP_ID =@MOP_ID,AC_Code=@AC_Code,InvNo=@InvNo,ChkNo=@ChkNo,SlipNo=@SlipNo,PreAmt=PreAmt,
	                       Amt=@Amt,DisAmt=@DisAmt,BalAmt=@BalAmt,SRT=@SRT,RCancel=@RCancel,checkDate=@checkDate where RID=@RID";
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(query, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.Text;
            sqlCmd.Parameters.AddWithValue("@Narr", Narr);
            sqlCmd.Parameters.AddWithValue("@MOP_ID", MOP_ID);
            sqlCmd.Parameters.AddWithValue("@AC_Code", AC_Code);

            sqlCmd.Parameters.AddWithValue("@InvNo", InvNo);
            sqlCmd.Parameters.AddWithValue("@ChkNo", ChkNo);
            sqlCmd.Parameters.AddWithValue("@SlipNo", SlipNo);



            sqlCmd.Parameters.AddWithValue("@Amt", Amt);
            sqlCmd.Parameters.AddWithValue("@DisAmt", DisAmt);

            sqlCmd.Parameters.AddWithValue("@BalAmt", BalAmt);
            sqlCmd.Parameters.AddWithValue("@checkDate", checkDate);
            sqlCmd.Parameters.AddWithValue("@RID", id);

            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            return dt;



        }

        public static DataTable sp_RV_GL_credit(int TypeCode, int AC_Code, int AC_Code2, string Narration, Double Debit, Double Credit, int RID, DateTime GLDate, int companyID)
        {
            string query = @"insert into GL (TypeCode,AC_Code,AC_Code2,Narration,Debit,Credit,RID,GLDate,CompID) 
                           values(@TypeCode,@AC_Code,@AC_Code2,@Narration,@Debit,@Credit,@RID,@gl,@companyID)
";
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(query, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.Text;
            sqlCmd.Parameters.AddWithValue("@TypeCode", TypeCode);
            sqlCmd.Parameters.AddWithValue("@AC_Code", AC_Code);
            sqlCmd.Parameters.AddWithValue("@AC_Code2", AC_Code2);

            sqlCmd.Parameters.AddWithValue("@Narration", Narration);
            sqlCmd.Parameters.AddWithValue("@Debit", Debit);
            sqlCmd.Parameters.AddWithValue("@Credit", Credit);

            sqlCmd.Parameters.AddWithValue("@RID", RID);
            sqlCmd.Parameters.AddWithValue("@gl", GLDate);
            sqlCmd.Parameters.AddWithValue("@companyID", companyID);

            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            return dt;



        }



        public static DataTable sp_PV_GL_Debit(int TypeCode, int AC_Code, int AC_Code2, string Narration, Double Debit, Double Credit, int RID, DateTime GLDate, int companyID)
        {
            string query = @"insert into GL (TypeCode,AC_Code,AC_Code2,Narration,Debit,Credit,RID,GLDate,CompID) 
                           values(@TypeCode,@AC_Code,@AC_Code2,@Narration,@Debit,@Credit,@RID,@gl,@companyID)
";
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(query, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.Text;
            sqlCmd.Parameters.AddWithValue("@TypeCode", TypeCode);
            sqlCmd.Parameters.AddWithValue("@AC_Code", AC_Code);
            sqlCmd.Parameters.AddWithValue("@AC_Code2", AC_Code2);

            sqlCmd.Parameters.AddWithValue("@Narration", Narration);
            sqlCmd.Parameters.AddWithValue("@Debit", Debit);
            sqlCmd.Parameters.AddWithValue("@Credit", Credit);

            sqlCmd.Parameters.AddWithValue("@RID", RID);
            sqlCmd.Parameters.AddWithValue("@gl", GLDate);
            sqlCmd.Parameters.AddWithValue("@companyID", companyID);

            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            return dt;



        }
        public static DataTable sp_PV_M_Update(int AC_Code, DateTime GLDate, int companyID, int ID)
        {
            string query = @"update PV_M set
	                     CompID=@CompID,EDate=@EDate,AC_Code =@AC_Code where RID= @Id";
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(query, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.Text;
            sqlCmd.Parameters.AddWithValue("@CompID", companyID);
            sqlCmd.Parameters.AddWithValue("@EDate", GLDate);
            sqlCmd.Parameters.AddWithValue("@AC_Code", AC_Code);
            sqlCmd.Parameters.AddWithValue("@Id", ID);



            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            return dt;



        }

        public static DataTable sp_PV_D_Update(String Narr, int MOP_ID, int AC_Code, int InvNo, int ChkNo, int SlipNo, Double PreAmt, Double Amt, double DisAmt, Double BalAmt, DateTime checkDate, int id)
        {
            string query = @"update PV_D set Narr =@Narr,MOP_ID =@MOP_ID,AC_Code=@AC_Code,InvNo=@InvNo,ChkNo=@ChkNo,SlipNo=@SlipNo,
	Amt=@Amt,DisAmt=@DisAmt,BalAmt=@BalAmt,checkDate=@checkDate where RID=@RID";
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(query, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.Text;
            sqlCmd.Parameters.AddWithValue("@Narr", Narr);
            sqlCmd.Parameters.AddWithValue("@MOP_ID", MOP_ID);
            sqlCmd.Parameters.AddWithValue("@AC_Code", AC_Code);

            sqlCmd.Parameters.AddWithValue("@InvNo", InvNo);
            sqlCmd.Parameters.AddWithValue("@ChkNo", ChkNo);
            sqlCmd.Parameters.AddWithValue("@SlipNo", SlipNo);



            sqlCmd.Parameters.AddWithValue("@Amt", Amt);
            sqlCmd.Parameters.AddWithValue("@DisAmt", DisAmt);

            sqlCmd.Parameters.AddWithValue("@BalAmt", BalAmt);
            sqlCmd.Parameters.AddWithValue("@checkDate", checkDate);
            sqlCmd.Parameters.AddWithValue("@RID", id);

            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            return dt;



        }

        public static DataTable PaymentVoucharIndex(DateTime start, DateTime End , int CompanyID)
        {
            string query = @"select m.*,c.Amt,rvm.AC_Title as customer,d.AC_Title as cashBAnk,c.BalAmt,c.checkDate,c.ChkNo,c.DisAmt,c.InvNo,c.MOP_ID,c.Narr,c.PreAmt,c.SlipNo,c.SRT,c.AC_Code as RV_TransactionCode,c.ID from PV_M as m
                             inner join PV_D as c on m.RID=c.RID
                             inner join COA_D as d on d.AC_Code=c.AC_Code
                             inner join COA_D rvm on rvm.AC_Code=m.AC_Code
                             inner join AspNetUsers u on u.AccessFailedCount=m.CompID
                             where (CAST(m.EDate as Date) >= CAST(@StartDate as Date) and CAST(m.EDate as Date) <= CAST(@EndDate as Date))
                             AND m.CompID = @CompID";
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(query, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.Text;

            sqlCmd.Parameters.AddWithValue("@StartDate", start);
            sqlCmd.Parameters.AddWithValue("@EndDate", End);
            sqlCmd.Parameters.AddWithValue("@CompID", CompanyID);

            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            return dt;

        }

        public static DataTable BookingSummary(DateTime dtStart, DateTime dtEnd, String userName, String type, int CompanyID)
        {
            string query = @"SELECT 
	                         OrderNo , Amount , OrderDate , OrderType  , KOTID , us.UserName , GST , Discount	
                             FROM tbl_Order PR
	                         INNER JOIN AspNetUsers us ON us.Id = PR.UserID
                             WHERE
                             ('All' = @userName OR us.[UserName] LIKE @userName)
                             AND ('0' = @type OR PR.[KOTID] LIKE @type)
                             AND PR.OrderDate BETWEEN @reportStartDate AND @reportEndDate AND PR.CompanyID = @CompanyID";
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(query, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.Text;
            sqlCmd.Parameters.AddWithValue("@reportStartDate", dtStart);
            sqlCmd.Parameters.AddWithValue("@reportEndDate", dtEnd);
            sqlCmd.Parameters.AddWithValue("@userName", userName);
            sqlCmd.Parameters.AddWithValue("@type", type);
            sqlCmd.Parameters.AddWithValue("@CompanyID", CompanyID);
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            return dt;
        }


        public static DataTable GetNewSerialNo()
        {
            string query = @"SELECT TOP 1 ISNULL(RIGHT(OrderNo, LEN(OrderNo) - 1), 0 ) AS OrdrID from tbl_Order  order by OrdrID desc";
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(query, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.Text;
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            return dt;
        }

        public static DataTable GetPaidCustomerByMonth(int month, int year)
        {
            var query = @"select DATEADD(month,@Month-1,DATEADD(year,@Year-1900,0))as ToDate,DATEADD(day,-1,DATEADD(month,@Month,DATEADD(year,@Year-1900,0))) as FromDate";
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(query, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.Text;
            sqlCmd.Parameters.AddWithValue("@Month", month);
            sqlCmd.Parameters.AddWithValue("@Year", year);
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            return dt;
        }

        public static DataTable GetPaidCustomerByMonth(DateTime fromDate, DateTime ToDate , int CompanyID)
        {
            var query = @"select c.CusName, SUM(g.Credit) AS [TOTAL AMOUNT],c.AC_Code
              from Customers c left join GL g
              ON c.AC_Code= g.AC_Code
              where  g.[GLDate]  between @StartDate and @EndDate AND c.CompanyID = CompanyID
              GROUP BY c.CusName , c.AC_Code";
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(query, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.Text;
            sqlCmd.Parameters.AddWithValue("@StartDate", fromDate);
            sqlCmd.Parameters.AddWithValue("@EndDate", ToDate);
            sqlCmd.Parameters.AddWithValue("@CompanyID", CompanyID);
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            return dt;
        }


        public static DataTable CategoryandLabWiseTest(DateTime dtStart, DateTime dtEnd, String userName)
        {
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(Report_CategoryandLabWiseTest, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.AddWithValue("@reportStartDate", dtStart);
            sqlCmd.Parameters.AddWithValue("@reportEndDate", dtEnd);
            sqlCmd.Parameters.AddWithValue("@userName", userName);
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            dt.TableName = "Report_CategoryandLabWiseTest";
            return dt;
        }

        public static DataTable ItemsSummary(DateTime dtStart, DateTime dtEnd, String Item)
        {
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand("Item_Summary", SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.AddWithValue("@reportStartDate", dtStart);
            sqlCmd.Parameters.AddWithValue("@reportEndDate", dtEnd);
            sqlCmd.Parameters.AddWithValue("@Item", Item);
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            dt.TableName = "Item_Summary";
            return dt;
        }

        public static DataTable BookingDetailSummary(DateTime dtStart, DateTime dtEnd, String userName, String type)
        {
            string _query = @"SELECT  OrderNo , Amount , OrderDate , OrderType  , PR.KOTID , us.UserName , GST , Discount
	                         ,Items.IName , Qty as Qty , Rate as Rate  
                              FROM 
                              	tbl_Order PR
                              	INNER JOIN AspNetUsers us ON us.Id = PR.UserID
                              	left join tbl_KOT on tbl_KOT.Id = PR.KOTID
                              	left join tbl_OrderDetails on tbl_OrderDetails.OrderId = PR.OrderId
                              	left join Items on Items.IID = tbl_OrderDetails.itemID
                              WHERE
                                  ('All' = @userName OR us.[UserName] LIKE @userName)
                              	AND ('0' = @type OR PR.[KOTID] LIKE @type)
                              	AND PR.OrderDate BETWEEN @reportStartDate AND @reportEndDate";
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(_query, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.Text;
            sqlCmd.Parameters.AddWithValue("@reportStartDate", dtStart);
            sqlCmd.Parameters.AddWithValue("@reportEndDate", dtEnd);
            sqlCmd.Parameters.AddWithValue("@userName", userName);
            sqlCmd.Parameters.AddWithValue("@type", type);
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            // dt.TableName = "Report_BookingDetailSummary";
            return dt;
        }

        public static DataTable MonthlySummary(DateTime dtStart, DateTime dtEnd)
        {
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(Report_MonthlySummary, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.AddWithValue("@reportStartDate", dtStart);
            sqlCmd.Parameters.AddWithValue("@reportEndDate", dtEnd);
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            dt.TableName = "Report_MonthlySummary";
            return dt;
        }

        public static DataTable MonthlySummary_Summary(DateTime dtStart, DateTime dtEnd)
        {
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(Report_MonthlySummary_Summary, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.AddWithValue("@reportStartDate", dtStart);
            sqlCmd.Parameters.AddWithValue("@reportEndDate", dtEnd);
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            dt.TableName = "Report_MonthlySummary_Summary";
            return dt;
        }

        public static DataTable BookingSummary_Report(DateTime dtStart, DateTime dtEnd, String userName)
        {
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(BookingSummary_ReportCount, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.AddWithValue("@reportStartDate", dtStart);
            sqlCmd.Parameters.AddWithValue("@reportEndDate", dtEnd);
            sqlCmd.Parameters.AddWithValue("@userName", userName);
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            dt.TableName = "BookingSummary_ReportCount";
            return dt;
        }

        public static DataTable BookingSummary_UserAmount(DateTime dtStart, DateTime dtEnd)
        {
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(BookingSummary_UserTotalAmount, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.AddWithValue("@reportStartDate", dtStart);
            sqlCmd.Parameters.AddWithValue("@reportEndDate", dtEnd);
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            dt.TableName = "BookingSummary_UserTotalAmount";
            return dt;
        }



        public static DataTable FreePatient(DateTime dtStart, DateTime dtEnd, Int32 docID)
        {
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(Report_FreePatients, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.AddWithValue("@dtStart", dtStart);
            sqlCmd.Parameters.AddWithValue("@dtEnd", dtEnd);
            sqlCmd.Parameters.AddWithValue("@docID", docID);
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            dt.TableName = "Report_FreePatients";
            return dt;
        }

        public static DataTable Receipt(String labNo)
        {
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(Report_Receipt, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.AddWithValue("@labNo", labNo);
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            dt.TableName = "Report_Receipt";
            return dt;
        }

        public static DataTable TestReportCount(DateTime dtStart, DateTime dtEnd, Int32 reportID, String userName)
        {
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(Report_TestReport_Count, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.AddWithValue("@dtStart", dtStart);
            sqlCmd.Parameters.AddWithValue("@dtEnd", dtEnd);
            sqlCmd.Parameters.AddWithValue("@reportID", reportID);
            sqlCmd.Parameters.AddWithValue("@userName", userName);
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            dt.TableName = "Report_TestReport_Count";
            return dt;
        }

        public static DataTable DiscountPatients(DateTime dtStart, DateTime dtEnd, Int32 docID)
        {
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(Report_DiscountPatients, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.AddWithValue("@dtStart", dtStart);
            sqlCmd.Parameters.AddWithValue("@dtEnd", dtEnd);
            sqlCmd.Parameters.AddWithValue("@docID", docID);
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            dt.TableName = "Report_DiscountPatients";
            return dt;
        }

        public static DataTable TestWiseDetailSumm_Count(DateTime dtStart, DateTime dtEnd, String userName)
        {
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(TestWiseDetailSummary_Count, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.AddWithValue("@reportStartDate", dtStart);
            sqlCmd.Parameters.AddWithValue("@reportEndDate", dtEnd);
            sqlCmd.Parameters.AddWithValue("@userName", userName);
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            dt.TableName = "TestWiseDetailSummary_Count ";
            return dt;
        }
        public static DataTable TestWiseDetailSumm(DateTime dtStart, DateTime dtEnd, String userName)
        {
            DataTable dt = new DataTable();
            SqlCommand sqlCmd = new SqlCommand(TestWiseDetailSummary, SqlHelper.DefaultSqlConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.AddWithValue("@reportStartDate", dtStart);
            sqlCmd.Parameters.AddWithValue("@reportEndDate", dtEnd);
            sqlCmd.Parameters.AddWithValue("@userName", userName);
            SqlDataAdapter adp = new SqlDataAdapter(sqlCmd);
            adp.Fill(dt);
            adp.Dispose();
            sqlCmd.Dispose();
            dt.TableName = "TestWiseDetailSummary ";
            return dt;
        }
    }
}
