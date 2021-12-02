﻿using Lib.Entity;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.Entity;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using SalesMngmt.Utility;

namespace SalesMngmt.Invoice
{
    public partial class ExpenseVoucher : MetroFramework.Forms.MetroForm
    {
        SaleManagerEntities db = null;
        List<Lib.Entity.ExpenseVoucherIndex_Result> list = null;
        int compID = 0;
        int obj = 0;
        int AcCode = 0;
        double Amt = 0;
        DateTime dt = DateTime.Now;
        int ChkNO = 0;
        int Narr = 0;
        int CustomerCode = 0;




        public ExpenseVoucher()
        {
            InitializeComponent();

            db = new SaleManagerEntities();
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
            var customerCount = db.Customers.Where(x => x.CompanyID == 0).FirstOrDefault();
            var AccountCount = db.COA_D.Where(x => x.CAC_Code == 1).FirstOrDefault();
            FillCombo(cmbxCustomer, db.COA_D.Where(x => x.CAC_Code == 16).ToList(), "AC_Title", "AC_Code", customerCount.AC_Code);
            FillCombo(cmbxAccount, db.COA_D.Where(x => x.CAC_Code == 1).ToList(), "AC_Title", "AC_Code",0 /*AccountCount.AC_Code*/);

            pnlMain.Hide();
            // var MyNewDateValue = DateTime.Today.AddDays(-10);
            list = db.ExpenseVoucherIndex(DateTime.Today.AddDays(-10), DateTime.Now).ToList();
            expenseVoucherIndexResultBindingSource.DataSource = list;
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
                list = db.ExpenseVoucherIndex(dtTo.Value, dtFrom.Value).ToList();
                expenseVoucherIndexResultBindingSource.DataSource = list;
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
            dtTranscation.Value = DateTime.Now;
            var customerCount = db.COA_D.Where(x => x.CAC_Code == 16).FirstOrDefault();
            var AccountCount = db.COA_D.Where(x => x.CAC_Code == 1).FirstOrDefault();
            FillCombo(cmbxCustomer, db.COA_D.Where(x => x.CAC_Code == 16).ToList(), "AC_Title", "AC_Code",0 /*customerCount.AC_Code*/);
            FillCombo(cmbxAccount, db.COA_D.Where(x => x.CAC_Code == 1).ToList(), "AC_Title", "AC_Code",0/* AccountCount.AC_Code*/);

            dtCheckDate.Value = DateTime.Now;
            //chkIsActive.Checked = false;
            txtAmount.Text = "";



        }

        private void btnSave_Click(object sender, EventArgs e)
        {/*txtArticalNo.Text == ""*/
            int code = Convert.ToInt32(cmbxAccount.SelectedValue);
            int customer = Convert.ToInt32(cmbxCustomer.SelectedValue);

            if (obj == 0)
            {
                //int compid = Convert.ToInt32(collection.CompID);

             //   var id = db.sp_RV_M_Insert(0, dtTranscation.Value, code, 0, "0").FirstOrDefault();
                //int sid = Convert.ToInt32(collection.SID);
                ////db1.SaveChanges();
                DbContextTransaction transaction = db.Database.BeginTransaction();
                EV_M obj = new EV_M();
                obj.AC_Code = code;
                //    obj.Create_Date = DateTime.Now;
                obj.EDate = dtTranscation.Value;
                obj.CompID = 0;
                obj.SID = 0;
             //   obj.Create_User_ID = collection.Create_User_ID;
               // obj.RID = collection.RID;
                db.EV_M.Add(obj);
                db.SaveChanges();
            //    collection.RV_CustomerCode = collection.Create_User_ID;

                int cashcode = Convert.ToInt32(code);
                int Expensecode = Convert.ToInt32(customer);

                var cash = db.COA_D.Where(x => x.AC_Code == cashcode).FirstOrDefault();

                var expense = db.COA_D.Where(x => x.AC_Code == Expensecode).FirstOrDefault();




             //   db.sp_RV_D_Insert(Convert.ToInt32(id), txtNarr.Text, 7, customer, 1, Convert.ToInt32(txtChkNo.Text), 1, 0, Convert.ToDouble(txtAmount.Text), 0, 0, 0, 0, dtCheckDate.Value);// int a = Convert.ToInt32(id);

                EV_D PV_D = new EV_D();

                PV_D.AC_Code = Expensecode.ToString();
                PV_D.Amt = Convert.ToDouble(txtAmount.Text.DefaultZero()).ToString();
                //     PV_D.checkDate = collection.checkDate;
                PV_D.ChkNo = Convert.ToInt32(txtChkNo.Text.DefaultZero()).ToString();//collection.ChkNo;
                PV_D.Narr = txtNarr.Text;//collection.Narr;
                //    PV_D.MOP_ID = 7;
              //  PV_D.ID = collection.ID;
                PV_D.RID = obj.RID;

                db.EV_D.Add(PV_D);


                GL gl = new GL();

                gl.RID = obj.RID;
                gl.TypeCode = 16;
                gl.GLDate = dtTranscation.Value;//collection.EDate;
                gl.CompID = 1;
                gl.SID = 1;
                gl.AC_Code = Convert.ToInt32(customer);
                gl.AC_Code2 = Convert.ToInt32(code);
                gl.Narration = cash.AC_Title + ":" + txtNarr.Text;
                gl.Debit = Convert.ToDouble(txtAmount.Text.DefaultZero());//Convert.ToDouble(collection.Amt);
                gl.Credit = 0;

                db.GL.Add(gl);

                GL gl1 = new GL();

                gl1.RID = obj.RID;
                gl1.TypeCode = 16;
                gl1.GLDate = dtTranscation.Value ;
                gl1.CompID = 1;
                gl1.SID = 1;
                gl1.AC_Code = Convert.ToInt32(code);
                gl1.AC_Code2 = Convert.ToInt32(customer);
                gl1.Narration = txtNarr.Text+ ":" + expense.AC_Title;
                gl1.Debit = 0;
                gl1.Credit = Convert.ToDouble(txtAmount.Text.DefaultZero());

                db.GL.Add(gl1);

                db.SaveChanges();



                transaction.Commit();







                //db.sp_RV_GL_credit(14, code, customer, Convert.ToInt32(txtNarr.Text), Convert.ToDouble(txtAmount.Text), 0, Convert.ToInt32(id), dtTranscation.Value);
                //db.sp_RV_GL_Debit(14, customer, code, Convert.ToInt32(txtNarr.Text), 0, Convert.ToDouble(txtAmount.Text), Convert.ToInt32(id), dtTranscation.Value);

            }
            else
            {


                DbContextTransaction transaction = db.Database.BeginTransaction();


                EV_M obj1 = db.EV_M.Where(x => x.RID == obj).FirstOrDefault();
                obj1.AC_Code = Convert.ToInt32(code);
                //    obj.Create_Date = DateTime.Now;
                obj1.EDate = dtTranscation.Value;
                obj1.RID = obj;
               // obj1.Create_User_ID = customer;
                db.Entry(obj1).State = EntityState.Modified;


                int cashcode = Convert.ToInt32(code);
                int Expensecode = Convert.ToInt32(customer);

                var cash = db.COA_D.Where(x => x.AC_Code == cashcode).FirstOrDefault();

                var expense = db.COA_D.Where(x => x.AC_Code == Expensecode).FirstOrDefault();



                EV_D PV_D = db.EV_D.Where(x => x.RID ==obj).FirstOrDefault();
                PV_D.AC_Code = Convert.ToInt32(customer).ToString();
                PV_D.Amt = Convert.ToDouble(txtAmount.Text.DefaultZero()).ToString();
                PV_D.ChkNo = txtChkNo.Text;
                PV_D.RID = obj;
                PV_D.Narr = txtNarr.Text;
                db.Entry(PV_D).State = EntityState.Modified;
                db.SaveChanges();

                var all = db.GL.Where(x => x.TypeCode == 16 && x.RID == obj);
                db.GL.RemoveRange(all);
                db.SaveChanges();


                GL gl = new GL();

                gl.RID = obj;
                gl.TypeCode = 16;
                gl.GLDate = dtTranscation.Value;//collection.EDate;
                gl.CompID = 1;
                gl.SID = 1;
                gl.AC_Code = Convert.ToInt32(customer);
                gl.AC_Code2 = Convert.ToInt32(code);
                gl.Narration = cash.AC_Title + ":" + txtNarr.Text;
                gl.Debit = Convert.ToDouble(txtAmount.Text.DefaultZero());//Convert.ToDouble(collection.Amt);
                gl.Credit = 0;

                db.GL.Add(gl);

                GL gl1 = new GL();

                gl1.RID = obj;
                gl1.TypeCode = 16;
                gl1.GLDate = dtTranscation.Value;
                gl1.CompID = 1;
                gl1.SID = 1;
                gl1.AC_Code = Convert.ToInt32(code);
                gl1.AC_Code2 = Convert.ToInt32(customer);
                gl1.Narration = txtNarr.Text + ":" + expense.AC_Title;
                gl1.Debit = 0;
                gl1.Credit = Convert.ToDouble(txtAmount.Text.DefaultZero());

                db.GL.Add(gl1);

                db.SaveChanges();
                transaction.Commit();


            }
            list = db.ExpenseVoucherIndex(dtTo.Value, dtFrom.Value).ToList();
            expenseVoucherIndexResultBindingSource.DataSource = list;

        
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
         int count=   CategorysDataGridView.Rows.Count;
            if (count != 0)
            {
                obj = Convert.ToInt32(CategorysDataGridView.Rows[e.RowIndex].Cells[0].Value);
                dtTranscation.Value = Convert.ToDateTime(CategorysDataGridView.Rows[e.RowIndex].Cells[2].Value.ToString());
                cmbxAccount.SelectedValue = Convert.ToInt32(CategorysDataGridView.Rows[e.RowIndex].Cells[3].Value);
                txtAmount.Text = Convert.ToDouble(CategorysDataGridView.Rows[e.RowIndex].Cells[18].Value).ToString();
                //   dtCheckDate.Value = Convert.ToDateTime(CategorysDataGridView.Rows[e.RowIndex].Cells[20].Value.ToString());
                txtChkNo.Text = Convert.ToInt32(CategorysDataGridView.Rows[e.RowIndex].Cells[21].Value).ToString();
                txtNarr.Text = CategorysDataGridView.Rows[e.RowIndex].Cells[24].Value.ToString();
                cmbxCustomer.SelectedValue = Convert.ToInt32(CategorysDataGridView.Rows[e.RowIndex].Cells[27].Value);
            }


        }
        public void expenseDetail(int a) {

            obj = a;
            EV_M rv_m = new EV_M();
            EV_D rv_d = new EV_D();

            rv_m = db.EV_M.Where(x => x.RID == a).FirstOrDefault();
            rv_d = db.EV_D.Where(x => x.RID == a).FirstOrDefault();

            dtTranscation.Value = Convert.ToDateTime(rv_m.EDate);
            cmbxAccount.SelectedValue = Convert.ToInt32(rv_m.AC_Code);
            txtAmount.Text = Convert.ToDouble(rv_d.Amt).ToString();
         //   dtCheckDate.Value = Convert.ToDateTime(rv_d.checkDate.ToString());
            txtChkNo.Text = Convert.ToInt32(rv_d.ChkNo).ToString();
            txtNarr.Text = rv_d.Narr.ToString();
            cmbxCustomer.SelectedValue = Convert.ToInt32(rv_d.AC_Code);
            // txtDiscount.Text = Convert.ToDouble(rv_d.DisAmt).ToString();


            pnlMain.Show();
            //txtChkNo.Focus();
            label3.Text = "EDIT";



        }

        private void pnlMain_Paint(object sender, PaintEventArgs e)
        {

        }

        private void btnSearch_Click(object sender, EventArgs e)
        {


            list = db.ExpenseVoucherIndex(dtTo.Value, dtFrom.Value).ToList();
            expenseVoucherIndexResultBindingSource.DataSource = list;













        }
    }








    //{
    //public ExpenseVoucher()
    //{
    //    InitializeComponent();
    //}
    //}
}
