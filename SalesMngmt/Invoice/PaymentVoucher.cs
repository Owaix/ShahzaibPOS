﻿using Lib.Entity;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using SalesMngmt.Utility;
using System.Data.Entity;
using Lib.Reporting;

namespace SalesMngmt.Invoice
{
    public partial class PaymentVoucher : MetroFramework.Forms.MetroForm
    {
        SaleManagerEntities db = null;
        List<Lib.Entity.PaymentVoucharIndex_Result> list = null;
        int compID = 0;
        int obj = 0;
        int AcCode = 0;
        double Amt = 0;
        DateTime dt = DateTime.Now;
        int ChkNO = 0;
        int Narr = 0;
        int CustomerCode = 0;




        public PaymentVoucher(int company)
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
            var customerCount = db.Vendors.Where(x => x.CompanyID == compID).FirstOrDefault();
            var AccountCount = db.COA_D.Where(x => x.CAC_Code == 1 && x.CompanyID == compID ).FirstOrDefault();
            FillCombo(cmbxCustomer, db.Vendors.Where(x => x.CompanyID == compID && x.InActive==false ).ToList(), "VendName", "AC_Code", 0/*Convert.ToInt32(customerCount.AC_Code)*/);
            FillCombo(cmbxAccount, db.COA_D.Where(x => x.CAC_Code == 1 && x.InActive==false && x.CompanyID==compID).ToList(), "AC_Title", "AC_Code",0 /*AccountCount.AC_Code*/);

            pnlMain.Hide();
            // var MyNewDateValue = DateTime.Today.AddDays(-10);
           var list1 = ReportsController.PaymentVoucharIndex(DateTime.Today.AddDays(-10), DateTime.Now , compID);
            paymentVoucharIndexResultBindingSource.DataSource = list1;
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
             var   list2 = ReportsController.PaymentVoucharIndex(dtTo.Value, dtFrom.Value, compID);
                paymentVoucharIndexResultBindingSource.DataSource = list2;
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
            var customerCount = db.Vendors.Where(x => x.CompanyID == compID).FirstOrDefault();
            var AccountCount = db.COA_D.Where(x => x.CAC_Code == 1 && x.CompanyID == compID).FirstOrDefault();
            FillCombo(cmbxCustomer, db.Vendors.Where(x => x.CompanyID == compID && x.InActive==false).ToList(), "VendName", "AC_Code", Convert.ToInt32(customerCount.AC_Code));
            FillCombo(cmbxAccount, db.COA_D.Where(x => x.CAC_Code == 1).ToList(), "AC_Title", "AC_Code",0 /*AccountCount.AC_Code*/);

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

                //int sid = Convert.ToInt32(collection.SID);
                ////db1.SaveChanges();
                DbContextTransaction transaction = db.Database.BeginTransaction();

                int aaa = Convert.ToInt32(txtChkNo.Text.DefaultZero());
                var id = ReportsController.sp_PV_M_Insert(compID, dtTranscation.Value, code,false);//db.sp_PV_M_Insert(0, dtTranscation.Value, code, 0, "0").FirstOrDefault();
                PV_D PV = new PV_D();
                PV.RID = Convert.ToInt32(id.Rows[0][0]);
                PV.Narr = txtNarr.Text;
                PV.MOP_ID = 7;
                PV.AC_Code = customer;
                PV.ChkNo = txtChkNo.Text.DefaultZero();
                PV.Amt = Convert.ToDouble(txtAmount.Text.DefaultZero());
                PV.checkDate = dtCheckDate.Value;

                db.PV_D.Add(PV);
                //    db.sp_PV_D_Insert(Convert.ToInt32(id), txtNarr.Text, 7, customer, 1, Convert.ToInt32(txtChkNo.Text ),1, 0, Convert.ToDouble(txtAmount.Text.DefaultZero()), 0, 0, 0, 0, dtCheckDate.Value);// int a = Convert.ToInt32(id);

                ReportsController.sp_PV_GL_Debit(15, customer, code, txtNarr.Text, Convert.ToDouble(txtAmount.Text.DefaultZero()), 0, Convert.ToInt32(id.Rows[0][0]), dtTranscation.Value, compID);
                ReportsController.sp_RV_GL_credit(15, code, customer, txtNarr.Text, 0, Convert.ToDouble(txtAmount.Text), Convert.ToInt32(id.Rows[0][0]), dtTranscation.Value, compID);

                db.SaveChanges();
                transaction.Commit();
            }
            else
            {
                DbContextTransaction transaction = db.Database.BeginTransaction();

                ReportsController.sp_PV_M_Update(code, dtCheckDate.Value, compID, obj);
              //  db.sp_PV_D_Update(obj, txtNarr.Text, 7, customer, 1, Convert.ToInt32(txtChkNo.Text), 1, 0, Convert.ToDouble(txtAmount.Text.DefaultZero()), 0, 0, 0, 0, dtCheckDate.Value);
                ReportsController.sp_PV_D_Update(txtNarr.Text, 0, customer, 0, Convert.ToInt32(txtChkNo.Text), 0, 0, Convert.ToDouble(txtAmount.Text.DefaultZero()), 0, 0, dtCheckDate.Value, obj);


                var all = db.GL.Where(x => x.TypeCode == 15 && x.RID == obj && x.CompID==compID);
                db.GL.RemoveRange(all);
                db.SaveChanges();
                //db.sp_PV_GL_Debit(15, customer, code, txtNarr.Text, Convert.ToDouble(txtAmount.Text.DefaultZero()), 0, Convert.ToInt32(obj), dtTranscation.Value, 7);
                //db.sp_PV_GL_credit(15, code, customer, txtNarr.Text, 0, Convert.ToDouble(txtAmount.Text.DefaultZero()), Convert.ToInt32(obj), dtTranscation.Value, 7);


                ReportsController.sp_PV_GL_Debit(15, customer, code, txtNarr.Text, Convert.ToDouble(txtAmount.Text.DefaultZero()), 0, Convert.ToInt32(obj), dtTranscation.Value, compID);
                ReportsController.sp_RV_GL_credit(15, code, customer, txtNarr.Text, 0, Convert.ToDouble(txtAmount.Text), Convert.ToInt32(obj), dtTranscation.Value, compID);


                transaction.Commit();

            }

           var  list1 = ReportsController.PaymentVoucharIndex(dtTo.Value, dtFrom.Value, compID);
            paymentVoucharIndexResultBindingSource.DataSource = list1;

            //    if (true)
            //    { MessageBox.Show("Please Provide ArticleNo", "", MessageBoxButtons.OK, MessageBoxIcon.Error); }
            //    else
            //    {
            //        // Lib.Entity.ArticleType obj = (Lib.Entity.ArticleType)articleTypeBindingSource.Current;

            //      //  var Currentobj = db.Articles.ToList().Find(x => x.ArticleNo == txtArticalNo.Text.Trim());// list.Find(x => x.Name == txtcat.Text.Trim());
            //        if (obj == 0)
            //        {/*Currentobj != null*/
            //            if (true)
            //            {
            //                MessageBox.Show("Artical Exists", "Duplicate", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            //                return;
            //            }
            //        }
            //        else
            //        {
            //            var articalTbl = db.Articles.Where(x => x.ProductID == obj).FirstOrDefault();
            //            //bool isCodeExist = db.Articles.Any(record =>
            //            //                     record.ArticleNo == //txtArticalNo.Text &&
            //            //                     record.ProductID != articalTbl.ProductID);
            //            //if (isCodeExist)
            //            //{
            //            //    MessageBox.Show("Artical Exists", "Duplicate", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            //            //    return;
            //            //}
            //        }

            //        Article ar = new Article();

            //        ar.ArticleTypeID = Convert.ToInt32(cmbxAccount.SelectedValue);//txtcat.Text.Trim();
            //        ar.StyleID = Convert.ToInt32(cmbxCustomer.SelectedValue);
            //        ar.ProductName = txtName.Text;
            //     //   ar.ArticleNo = txtArticalNo.Text;
            //        ar.IsDelete = chkIsActive.Checked;

            //        if (obj == 0)
            //        {
            //            db.Articles.Add(ar);
            //        }
            //        else
            //        {

            //            var articalTbl = db.Articles.Where(x => x.ProductID == obj).FirstOrDefault();

            //            var result = db.Articles.SingleOrDefault(b => b.ProductID == articalTbl.ProductID);
            //            if (result != null)
            //            {


            //                result.ArticleTypeID = Convert.ToInt32(cmbxAccount.SelectedValue);//txtcat.Text.Trim();
            //                result.StyleID = Convert.ToInt32(cmbxCustomer.SelectedValue);
            //                result.ProductName = txtName.Text;
            //               // result.ArticleNo = txtArticalNo.Text;
            //                result.IsDelete = chkIsActive.Checked;

            //            }
            //        }
            //        db.SaveChanges();
            pnlMain.Hide();
            //        obj = 0;
            //        list = db.RecivedVoucharIndex().ToList();
            //        spgetArticleResultBindingSource.DataSource = list;

            //        //list = db.ArticleTypes.ToList();
            //        //articleTypeBindingSource.DataSource = list;
            //    }
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



        }

        public void Payment(int a)
        {



            obj = a;
            PV_M rv_m = new PV_M();
            PV_D rv_d = new PV_D();

            rv_m = db.PV_M.Where(x => x.RID == a).FirstOrDefault();
            rv_d = db.PV_D.Where(x => x.RID == a).FirstOrDefault();

            dtTranscation.Value = Convert.ToDateTime(rv_m.EDate);
            cmbxAccount.SelectedValue = Convert.ToInt32(rv_m.AC_Code);
            txtAmount.Text = Convert.ToDouble(rv_d.Amt).ToString();
            dtCheckDate.Value = Convert.ToDateTime(rv_d.checkDate.ToString());
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


            //list = db.PaymentVoucharIndex(dtTo.Value, dtFrom.Value).ToList();
            //paymentVoucharIndexResultBindingSource.DataSource = list;

            var list1 = ReportsController.PaymentVoucharIndex(dtTo.Value, dtFrom.Value, compID);
            paymentVoucharIndexResultBindingSource.DataSource = list1;











        }

        private void txtChkNo_KeyPress(object sender, KeyPressEventArgs e)
        {
            // allows 0-9, backspace, and decimal
            if (((e.KeyChar < 48 || e.KeyChar > 57) && e.KeyChar != 8 && e.KeyChar != 46))
            {
                e.Handled = true;
                return;
            }

            // checks to make sure only 1 decimal is allowed
            if (e.KeyChar == 46)
            {
                if ((sender as TextBox).Text.IndexOf(e.KeyChar) != -1)
                    e.Handled = true;
            }
        }

        private void txtNarr_KeyPress(object sender, KeyPressEventArgs e)
        {
            // allows 0-9, backspace, and decimal
            if (((e.KeyChar < 48 || e.KeyChar > 57) && e.KeyChar != 8 && e.KeyChar != 46))
            {
                e.Handled = true;
                return;
            }

            // checks to make sure only 1 decimal is allowed
            if (e.KeyChar == 46)
            {
                if ((sender as TextBox).Text.IndexOf(e.KeyChar) != -1)
                    e.Handled = true;
            }
        }

        private void cmbxUnit_Click(object sender, EventArgs e)
        {

        }
    }



}
