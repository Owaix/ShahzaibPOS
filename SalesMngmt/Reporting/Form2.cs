using Lib.Model;
using Microsoft.Reporting.WinForms;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Windows.Forms;

namespace DIagnoseMgmt
{
    public partial class Form2 : Form
    {
        List<SaleInvoice> List = null;
        public Form2(List<SaleInvoice> list)
        {
            InitializeComponent();
            List = list;
        }

        private void Form2_Load(object sender, EventArgs e)
        {
            ReportDataSource rds = new ReportDataSource("Ds", List);
            this.reportViewer1.LocalReport.DataSources.Clear();
            this.reportViewer1.LocalReport.DataSources.Add(rds);
            this.reportViewer1.RefreshReport();
        }

        public DataTable RunStoredProc(String SpName, object[] parameters, CommandType type = CommandType.Text)
        {
            DataTable dataTable = new DataTable();
            SqlConnection con = null;
            try
            {
                con = new SqlConnection(ConfigurationManager.ConnectionStrings["MyDBEntities"].ToString());
                SqlCommand cmd = new SqlCommand(SpName, con);
                if (parameters != null && parameters.Any())
                {
                    cmd.Parameters.AddRange(parameters);
                }
                cmd.CommandType = type;
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(cmd);
                sqlDataAdapter.Fill(dataTable);
                return dataTable;
            }
            catch (Exception ex)
            {

            }
            finally
            {
                if (con != null)
                {
                    con.Close();
                }

            }
            return dataTable;
        }
    }
}
