﻿using Lib.Entity;
using Lib.Reporting;
using SalesMngmt.Utility;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Windows.Forms;

namespace SalesMngmt.Invoice
{
    public partial class ReceiveVoucher : MetroFramework.Forms.MetroForm
    {
        SaleManagerEntities db = null;
        List<Lib.Entity.RecivedVoucharIndex_Result> list = null;
        int compID = 0;
        int obj = 0;
        int AcCode = 0;
        double Amt = 0;
        DateTime dt = DateTime.Now;
        int ChkNO = 0;
        int Narr = 0;
        int CustomerCode = 0;




        public ReceiveVoucher(int company)
        {
            InitializeComponent();

            db = new SaleManagerEntities();
            compID = company;

        }


        private void Category_Load(object sender, EventArgs e)
        {
            //cat type = new cat();
            //DataAccess access = new DataAccess();
            //type.PType_ID = 1;
            //var con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString);
            //con.Open();
            //SqlTransaction trans = con.BeginTransaction();
            //var objcat = access.Get<cat>("Sp_cat_Select", type, con, trans);
            var customerCount = db.Customers.Where(x => x.CompanyID == 0 && x.InActive == false).FirstOrDefault();
            var AccountCount = db.COA_D.Where(x => x.CAC_Code == 1 && x.CompanyID == compID && x.InActive == false).FirstOrDefault();
            FillCombo(cmbxCustomer, db.Customers.Where(x => x.CompanyID == compID && x.InActive == false).ToList(), "CusName", "AC_Code", customerCount.AC_Code);
            FillCombo(cmbxAccount, db.COA_D.Where(x => x.CAC_Code == 1 && x.CompanyID == compID && x.InActive == false).ToList(), "AC_Title", "AC_Code", 0 /*AccountCount.AC_Code*/);

            pnlMain.Hide();
            // var MyNewDateValue = DateTime.Today.AddDays(-10);
            var list1 = ReportsController.RecivedVoucharIndex(DateTime.Today.AddDays(-10), DateTime.Now, compID);
            recivedVoucharIndexResultBindingSource.DataSource = list1;
        }
        public void FillCombo(ComboBox comboBox, object obj, String Name, String ID, int selected)
        {
            comboBox.DataSource = obj;
            comboBox.DisplayMember = Name; // Column Name
            comboBox.ValueMember = ID;  // Column Name
            comboBox.SelectedValue = selected;
        }

        private void lblAdd_Click(object sender, EventArgs e)
        {
            clear();
            pnlMain.Show();
            GetDocCode();
            // txtChkNo.Focus();
            label3.Text = "ADD";
            obj = 0;
        }

        private void lblEdit_Click(object sender, EventArgs e)
        {
            if (obj == 0)
            {

                MessageBox.Show("Select any row first");

            }
            else
            {

                //var tbl = db.Articles.Where(x => x.ProductID == obj).FirstOrDefault();

                ////txtArticalNo.Text = tbl.ArticleNo;
                //txtChkNo.Text = tbl.ProductName;
                //cmbxAccount.SelectedValue = tbl.ArticleTypeID;
                //cmbxCustomer.SelectedValue = tbl.StyleID;
                //chkIsActive.Checked = (bool)tbl.IsDelete;


                pnlMain.Show();
                //txtChkNo.Focus();
                label3.Text = "EDIT";
            }



        }

        #region -- Global variables start --

        string docCode;

        #endregion -- Global variable end --


        private void btnCancel_Click(object sender, EventArgs e)
        {
            pnlMain.Hide();
            //  Lib.Entity.ArticleType us = (Lib.Entity.ArticleType)articleTypeBindingSource.Current;
            obj = 0;
            if (obj == 0)
            {
                clear();
                var list = ReportsController.RecivedVoucharIndex(dtTo.Value, dtFrom.Value, compID);
                recivedVoucharIndexResultBindingSource.DataSource = list;
            }
        }

        //public void alluser(string username)
        //{
        //    lblUserName.Text = username;
        //}

        public void clear()
        {
            txtNarr.Text = "";
            txtChkNo.Text = "";
            txtDiscount.Text = "";
            dtTranscation.Value = DateTime.Now;
            var customerCount = db.Customers.Where(x => x.CompanyID == compID && x.InActive == false).FirstOrDefault();
            var AccountCount = db.COA_D.Where(x => x.CAC_Code == 1 && x.CompanyID == compID && x.InActive == false).FirstOrDefault();
            FillCombo(cmbxCustomer, db.Customers.Where(x => x.CompanyID == compID && x.InActive == false).ToList(), "CusName", "AC_Code", customerCount.AC_Code);
            FillCombo(cmbxAccount, db.COA_D.Where(x => x.CAC_Code == 1 && x.CompanyID == compID && x.InActive == false).ToList(), "AC_Title", "AC_Code", 0 /*AccountCount.AC_Code*/);

            dtCheckDate.Value = DateTime.Now;
            //chkIsActive.Checked = false;
            txtAmount.Text = "";



        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            int code = Convert.ToInt32(cmbxAccount.SelectedValue);
            int customer = Convert.ToInt32(cmbxCustomer.SelectedValue);
            txtDiscount.Text = Convert.ToDouble(txtDiscount.Text == "" ? "0" : txtDiscount.Text).ToString();
            if (obj == 0)
            {

                DbContextTransaction transaction = db.Database.BeginTransaction();


                var id = ReportsController.sp_RV_M_Insert(compID, dtTranscation.Value, code, false);
                RV_D rv = new RV_D();
                rv.RID = Convert.ToInt32(id.Rows[0][0]);
                rv.Narr = txtNarr.Text;
                rv.MOP_ID = 7;
                rv.AC_Code = customer.ToString();
                rv.ChkNo = Convert.ToInt32(txtChkNo.Text.DefaultZero());
                rv.DisAmt = Convert.ToDouble(txtDiscount.Text.DefaultZero());
                rv.Amt = Convert.ToDouble(txtAmount.Text.DefaultZero());
                rv.checkDate = dtCheckDate.Value;
                db.RV_D.Add(rv);

                GL gl = new GL();
                gl.TypeCode = 14;
                gl.AC_Code = code;
                gl.AC_Code2 = Convert.ToInt32(cmbxCustomer.SelectedValue);
                gl.Narration = txtNarr.Text;
                gl.Debit = Convert.ToDouble(txtAmount.Text.DefaultZero());
                gl.Credit = 0;
                gl.RID = Convert.ToInt32(id);
                gl.GLDate = dtTranscation.Value;
                gl.MOP_ID = 7;
                db.GL.Add(gl);


                GL gl2 = new GL();
                gl2.TypeCode = 14;
                gl2.AC_Code = Convert.ToInt32(cmbxCustomer.SelectedValue);// customer;
                gl2.AC_Code2 = code;
                gl2.Narration = txtNarr.Text;
                gl2.Debit = 0;
                gl2.Credit = Convert.ToDouble(txtAmount.Text.DefaultZero());
                gl2.RID = Convert.ToInt32(id);
                gl2.GLDate = dtTranscation.Value;
                gl2.MOP_ID = 7;
                db.GL.Add(gl2);

                //if (txtDiscount.Text.Equals("") || txtDiscount.Text.Equals("0")) {

                //}
                //else
                //{

                //    var Expense = db.COA_D.Where(x => x.AC_Code == 16000001).FirstOrDefault();
                //    var customerDetial = db.COA_D.Where(x => x.AC_Code == customer).FirstOrDefault();
                //    db.sp_RV_GL_credit(14, Expense.AC_Code, customer, customerDetial.AC_Title, Convert.ToDouble(txtDiscount.Text.DefaultZero()), 0, Convert.ToInt32(id), dtTranscation.Value);
                //    db.sp_RV_GL_Debit(14, customer, code, Expense.AC_Title, 0, Convert.ToDouble(txtDiscount.Text.DefaultZero()), Convert.ToInt32(id), dtTranscation.Value);
                //}
                db.SaveChanges();
                transaction.Commit();
            }
            else
            {
                DbContextTransaction transaction = db.Database.BeginTransaction();
                ReportsController.sp_RV_M_Update(compID, dtCheckDate.Value, code, obj);
                db.sp_RV_D_Update(obj, txtNarr.Text, 7, customer, 1, Convert.ToInt32(txtChkNo.Text.DefaultZero()), 1, 0, Convert.ToDouble(txtAmount.Text.DefaultZero()), Convert.ToDouble(txtDiscount.Text.DefaultZero()), 0, 0, 0, dtCheckDate.Value);

                var all = db.GL.Where(x => x.TypeCode == 14 && x.RID == obj);
                db.GL.RemoveRange(all);
                db.SaveChanges();

                GL gl = new GL();
                gl.TypeCode = 14;
                gl.AC_Code = code;
                gl.AC_Code2 = customer;
                gl.Narration = txtNarr.Text;
                gl.Debit = Convert.ToDouble(txtAmount.Text.DefaultZero());
                gl.Credit = 0;
                gl.RID = obj;
                gl.GLDate = dtTranscation.Value;
                gl.MOP_ID = 7;
                db.GL.Add(gl);

                GL gl2 = new GL();
                gl2.TypeCode = 14;
                gl2.AC_Code = customer;
                gl2.AC_Code2 = code;
                gl2.Narration = txtNarr.Text;
                gl2.Debit = 0;
                gl2.Credit = Convert.ToDouble(txtAmount.Text.DefaultZero());
                gl2.RID = obj;
                gl2.GLDate = dtTranscation.Value;



                gl2.MOP_ID = 7;
                db.GL.Add(gl2);

                //if (txtDiscount.Text.Equals("") || txtDiscount.Text.Equals("0"))
                //{

                //}
                //else
                //{

                //    var Expense = db.COA_D.Where(x => x.AC_Code == 16000001).FirstOrDefault();
                //    var customerDetial = db.COA_D.Where(x => x.AC_Code == customer).FirstOrDefault();
                //    db.sp_RV_GL_credit(14, Expense.AC_Code, customer, customerDetial.AC_Title, Convert.ToDouble(txtDiscount.Text.DefaultZero()), 0,obj, dtTranscation.Value);
                //    db.sp_RV_GL_Debit(14, customer, code, Expense.AC_Title, 0, Convert.ToDouble(txtDiscount.Text.DefaultZero()), obj, dtTranscation.Value);
                //}




                db.SaveChanges();
                transaction.Commit();
            }

            list = db.RecivedVoucharIndex(dtTo.Value, dtFrom.Value).ToList();
            recivedVoucharIndexResultBindingSource.DataSource = list;

            pnlMain.Hide();

            clear();
        }
        private void catDataGridView_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            CategorysDataGridView.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
        }

        #region -- Helper Method Start --
        public void GetDocCode()
        {
            //catList obj = new catList(new cat { }.Select());
            //docCode = "DOC-" + (obj.Count + 1);
        }

        private void toolStripTextBoxFind_Leave(object sender, EventArgs e)
        {
            try
            {
                if (toolStripTextBoxFind.Text.Trim().Length == 0) { CategorysDataGridView.DataSource = list; }
                else
                {
                    // CategorysDataGridView.DataSource = list.FindAll(x => x.ArticleType1.ToLower().Contains(toolStripTextBoxFind.Text.ToLower().Trim()));
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        //
        #endregion -- Helper Method End --

        private void CategorysDataGridView_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            //  var abc=   CategorysDataGridView.Rows[e.RowIndex].Cells[0].Value;
        }

        private void CategorysDataGridView_CellClick(object sender, DataGridViewCellEventArgs e)
        {

            obj = Convert.ToInt32(CategorysDataGridView.Rows[e.RowIndex].Cells[0].Value);
            dtTranscation.Value = Convert.ToDateTime(CategorysDataGridView.Rows[e.RowIndex].Cells[2].Value.ToString());
            cmbxAccount.SelectedValue = Convert.ToInt32(CategorysDataGridView.Rows[e.RowIndex].Cells[3].Value);
            txtAmount.Text = Convert.ToDouble(CategorysDataGridView.Rows[e.RowIndex].Cells[16].Value).ToString();
            dtCheckDate.Value = Convert.ToDateTime(CategorysDataGridView.Rows[e.RowIndex].Cells[20].Value.ToString());
            txtChkNo.Text = Convert.ToInt32(CategorysDataGridView.Rows[e.RowIndex].Cells[21].Value).ToString();
            txtNarr.Text = CategorysDataGridView.Rows[e.RowIndex].Cells[25].Value.ToString();
            cmbxCustomer.SelectedValue = Convert.ToInt32(CategorysDataGridView.Rows[e.RowIndex].Cells[29].Value);
            txtDiscount.Text = Convert.ToDouble(CategorysDataGridView.Rows[e.RowIndex].Cells[22].Value).ToString();


        }

        public void received(int a)
        {


            obj = a;
            RV_M rv_m = new RV_M();
            RV_D rv_d = new RV_D();
            rv_m = db.RV_M.Where(x => x.RID == a).FirstOrDefault();
            rv_d = db.RV_D.Where(x => x.RID == a).FirstOrDefault();

            dtTranscation.Value = Convert.ToDateTime(rv_m.EDate);
            cmbxAccount.SelectedValue = Convert.ToInt32(rv_m.AC_Code);
            txtAmount.Text = Convert.ToDouble(rv_d.Amt).ToString();
            dtCheckDate.Value = Convert.ToDateTime(rv_d.checkDate.ToString());
            txtChkNo.Text = Convert.ToInt32(rv_d.ChkNo).ToString();
            txtNarr.Text = rv_d.Narr.ToString();
            cmbxCustomer.SelectedValue = Convert.ToInt32(rv_d.AC_Code);
            txtDiscount.Text = Convert.ToDouble(rv_d.DisAmt).ToString();


            pnlMain.Show();
            //txtChkNo.Focus();
            label3.Text = "EDIT";

        }

        private void pnlMain_Paint(object sender, PaintEventArgs e)
        {

        }

        private void btnSearch_Click(object sender, EventArgs e)
        {


            var list = ReportsController.RecivedVoucharIndex(dtTo.Value, dtFrom.Value, compID);
            recivedVoucharIndexResultBindingSource.DataSource = list;













        }
    }










    //{
    //    public ReceiveVoucher()
    //    {
    //        InitializeComponent();
    //    }
    //}
}
