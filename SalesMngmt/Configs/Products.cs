﻿using Lib;
using Lib.Entity;
using Lib.Model;
using Lib.Utilities;
using SalesMngmt.Utility;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Windows.Forms;

namespace SalesMngmt.Configs
{
    public partial class Products : MetroFramework.Forms.MetroForm
    {
        SaleManagerEntities db = null;
        List<Lib.Entity.Items> list = null;
        int compID = 0;
        public Products(int comID)
        {
            InitializeComponent();
            db = new SaleManagerEntities();
            compID = comID;
        }

        private void Products_Load(object sender, EventArgs e)
        {
            pnlMain.Hide();
            list = db.Items.Where(x => x.CompanyID == compID ).ToList();

            ProdBindingSource.DataSource = list;
            FillCombo(cmbcUni, db.I_Unit.Where(x => x.CompanyID == compID && x.active==false).ToList(), "IUnit", "unit_id", 1);
            FillCombo(cmbxCat, db.Items_Cat.Where(x => x.CompanyID == compID && x.isDeleted == false).ToList(), "Cat", "CatID", 1);
            FillCombo(cmbxMak, db.Item_Maker.Where(x => x.CompanyID == compID && x.IsDelete == false).ToList(), "Name", "MakerId", 1);
            FillCombo(cmbxSizes, db.Sizes.AsNoTracking().Where(x=>x.CompanyID==compID && x.IsDeleted==false).ToList(), "SizeName", "SizeID", 1);
            FillCombo(cmbxArticle, db.Article.AsNoTracking().Where(x => x.CompanyID == compID && x.IsDelete == false).ToList(), "ArticleNo", "ProductID", 1);
            FillCombo(cmbxColor, db.Colors.AsNoTracking().Where(x => x.CompanyID == compID && x.IsDeleted == false).ToList(), "Name", "ColorID", 1);
            FillCombo(CmbxStylr, db.Styles.AsNoTracking().Where(x => x.CompanyID == compID && x.IsDeleted == false).ToList(), "StyleName", "StyleID", 1);
            FillCombo(cmbxArticalType, db.ArticleTypes.AsNoTracking().Where(x => x.CompanyID == compID && x.IsDeleted == false).ToList(), "ArticleTypeName", "ArticleTypeID", 1);
        }

        private void lblAdd_Click(object sender, EventArgs e)
        {
            ProdBindingSource.AddNew();
            pnlMain.Show();
            txtProdName.Focus();
            label3.Text = "ADD";
            string path = Application.StartupPath + "\\Img\\124444444.png";
            pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            pictureBox1.Image = Image.FromFile(path);
        }

        public void openForm()
        {

            ProdBindingSource.AddNew();
            pnlMain.Show();
            txtProdName.Focus();
            label3.Text = "ADD";
            string path = Application.StartupPath + "\\Img\\124444444.png";
            pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            pictureBox1.Image = Image.FromFile(path);


        }
        private void lblEdit_Click(object sender, EventArgs e)
        {
            try
            {
                Items obj = (Items)ProdBindingSource.Current;
                var item = db.Items.Where(x => x.IID == obj.IID && x.CompanyID==compID).FirstOrDefault();
                if (item != null)
                {
                    obj.BarCode_ID = item.BarCode_ID;
                }
                pnlMain.Show();
                txtProdName.Focus();
                label3.Text = "EDIT";
                string path = Application.StartupPath + "\\Img\\" + obj.BarCode_ID;
                //string path = Application.StartupPath.Substring(0, (Application.StartupPath.Length - 10)) + "\\Img\\" + obj.BarCode_ID;
                openFileDialog1.FileName = path;
                label21.Text = obj.BarCode_ID;
                pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
                // pictureBox1.Image = Image.FromFile(path);
                pictureBox1.Image = Utillityfunctions.LoadImage(item.Img);
            }
            catch (Exception)
            {
                pictureBox1.Image = Image.FromFile(Application.StartupPath + "\\Img\\124444444.png");
            }

        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            pnlMain.Hide();
            Lib.Entity.Items us = (Lib.Entity.Items)ProdBindingSource.Current;
            if (us.IID == 0)
            {
                ProdBindingSource.RemoveCurrent();
                list = db.Items.AsNoTracking().Where(x => x.CompanyID == compID).ToList();
                ProdBindingSource.DataSource = list;
            }
            else
            {

                ProdBindingSource.Clear();
                var listcancel = db.Items.AsNoTracking().Where(x => x.CompanyID == compID).ToList();
                ProdBindingSource.DataSource = listcancel;
            }

        }
        public int GenerateRandomNo()
        {
            int _min = 100000;
            int _max = 999999;
            Random _rdm = new Random();
            return _rdm.Next(_min, _max);
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            double checkStockQuantity;
            bool isAdd = true;
            SqlConnection con = null;
            SqlTransaction trans = null;
            //DbContextTransaction transaction = db.Database.BeginTransaction();

            try
            {
                if (txtProdName.Text == "")
                {
                    MessageBox.Show("Please Provide Product Name", "", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
                else if (Convert.ToInt16(cmbxCat.SelectedValue) < 1)
                {
                    MessageBox.Show("Please Provide Category", "", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
                else
                //if (true)
                {
                    Lib.Entity.Items obj = (Lib.Entity.Items)ProdBindingSource.Current;

                    var Currentobj = list.Find(x => x.IName == txtProdName.Text.Trim() && x.CompanyID==compID);

                    if (obj.IID == 0)
                    {
                        //var bar = list.Find(x => x.BarcodeNo == txtBarCode.Text.Trim());
                        //if (bar != null)
                        //{
                        //    //MessageBox.Show("BarcodeNo Already Exists", "Duplicate", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        //    //return;
                        //}

                        bool isCodeExist = list.Any(record =>
                                    record.IName == obj.IName &&
                                    record.IID != obj.IID &&
                                    record.CompanyID==compID);

                        bool BarcodeNo = list.Any(record =>
                                           record.BarcodeNo == obj.BarcodeNo &&
                                           record.IID != obj.IID
                                           && record.CompanyID == compID);


                        if (obj.IName == "")
                        {
                            bool isCodeempty = list.Any(record =>
                                             record.IName == obj.IName &&
                                             record.IID != obj.IID
                                             && record.CompanyID == compID);

                        }

                        else if (isCodeExist)
                        {
                            MessageBox.Show("Product Name Already Exists", "Duplicate", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            return;
                        }

                        else if (BarcodeNo)
                        {
                            MessageBox.Show("BarcodeNo Already Exists", "Duplicate", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            return;
                        }
                    }
                    else
                    {
                        bool isCodeExist = list.Any(record =>
                                   record.IName == obj.IName &&
                                   record.IID != obj.IID
                                   && record.CompanyID == compID);

                        bool BarcodeNo = list.Any(record =>
                                           record.BarcodeNo == obj.BarcodeNo &&
                                           record.IID != obj.IID
                                           && record.CompanyID == compID);


                        if (obj.IName == "")
                        {
                            bool isCodeempty = list.Any(record =>
                                             record.IName == obj.IName &&
                                             record.IID != obj.IID
                                             && record.CompanyID == compID);

                        }

                        else if (isCodeExist)
                        {
                            MessageBox.Show("Product Name Already Exists", "Duplicate", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            return;
                        }

                        else if (BarcodeNo)
                        {
                            MessageBox.Show("BarcodeNo Already Exists", "Duplicate", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            return;
                        }
                    }

                    string path = Application.StartupPath;
                    string filename = System.IO.Path.GetFileName(openFileDialog1.FileName);
                    string fileNameOnly = Path.GetFileNameWithoutExtension(filename);
                    string extension = Path.GetExtension(filename);

                    if (filename == null)
                    {
                        MessageBox.Show("Please select a valid image.");
                        return;
                    }
                    else
                    {
                        try
                        {
                            //if (!File.Exists(path + "\\Img\\" + filename))
                            //{
                            //    System.IO.File.Copy(openFileDialog1.FileName, path + "\\Img\\" + filename);
                            //}
                        }
                        catch (Exception ex)
                        {
                            var ds = "";
                        }
                    }



                    if (obj.IID > 0)
                    {
                        isAdd = false;
                    }

                    DataAccess access = new DataAccess();
                    COA coa = new COA();
                    String Inventorycode = "";

                    int[] vals = new int[3] { 14, 15, 4 };

                    for (int i = 0; i < vals.Length; i++)
                    {
                        if (isAdd)
                        {
                            coa.AC_Code = vals[i];
                            con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString);
                            con.Open();
                            trans = con.BeginTransaction();
                            Inventorycode = access.GetScalar("GetAc_Code", coa, con, trans);
                            //using (var db = new DistributionErpEntities())
                            //{
                            COA_D coaD = new COA_D();
                            coaD.CAC_Code = vals[i];
                            coaD.PType_ID = 1;
                            coaD.ZID = 0;
                            coaD.AC_Code = Convert.ToInt32(Inventorycode);
                            coaD.AC_Title = txtProdName.Text.Trim();
                            coaD.DR = 0;
                            coaD.CR = 0;
                            coaD.Qty = 0;
                            coaD.CompanyID = compID;
                            db.COA_D.Add(coaD);

                            vals[i] = Convert.ToInt32(Inventorycode);
                        }

                    }

                    if (isAdd == false)
                    {
                        con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString);
                        con.Open();
                      //  trans = con.BeginTransaction();

                        var inc = db.COA_D.SingleOrDefault(x => x.AC_Code == obj.AC_Code_Inc && x.CompanyID==compID);
                        var inv = db.COA_D.SingleOrDefault(x => x.AC_Code == obj.AC_Code_Inv && x.CompanyID == compID);
                        var cost = db.COA_D.SingleOrDefault(x => x.AC_Code == obj.AC_Code_Cost && x.CompanyID == compID);

                        inc.AC_Title = txtProdName.Text.Trim();
                        inv.AC_Title = txtProdName.Text.Trim();
                        cost.AC_Title = txtProdName.Text.Trim();
                        //  coa.AC_Code = inc.AC_Code;

                        // var inv = db.COA_D.Where(x => x.AC_Code == obj.AC_Code_Inv).FirstOrDefault();

                    }
                    db.SaveChanges();

                    if (isAdd)
                    {
                        GL gl = new GL();
                        gl.RID = 0;
                        gl.RID2 = 0;
                        gl.TypeCode = 0;
                        gl.GLDate = DateTime.Now;
                        gl.AC_Code = Convert.ToInt32(Inventorycode);
                        gl.AC_Code2 = 12000001;
                        gl.Narration = "Opening Entry";
                        gl.Qty_IN = Convert.ToDouble(txtOpenQ.Text.DefaultZero());
                        gl.Debit = Convert.ToDouble(txtOpenQ.Text.DefaultZero()) * Convert.ToDouble(txtPurchase.Text.DefaultZero());
                        gl.Credit = 0;
                        gl.CompID = compID;
                        db.GL.Add(gl);

                        ////capital credit
                        GL glCapital = new GL();
                        glCapital.RID = 0;
                        glCapital.RID2 = 0;
                        glCapital.TypeCode = 0;
                        glCapital.GLDate = DateTime.Now;
                        glCapital.AC_Code = 12000001;
                        glCapital.AC_Code2 = Convert.ToInt32(Inventorycode);
                        glCapital.Narration = "opening Item :" + txtProdName.Text.Trim();
                        glCapital.Qty_IN = Convert.ToDouble(txtOpenQ.Text.DefaultZero());
                        glCapital.Debit = 0;
                        glCapital.Credit = Convert.ToDouble(txtOpenQ.Text.DefaultZero()) * Convert.ToDouble(txtPurchase.Text.DefaultZero());
                        glCapital.CompID = compID;
                        db.GL.Add(glCapital);
                    }
                    else
                    {

                        var gl = db.GL.SingleOrDefault(x => x.AC_Code == obj.AC_Code_Inv && x.TypeCode == 0 && x.CompID == compID);
                        var glCapital = db.GL.SingleOrDefault(x => x.AC_Code2 == obj.AC_Code_Inv && x.TypeCode == 0 && x.CompID == compID);
                        gl.Narration = "Opening Entry";
                        glCapital.Narration = "opening Item :" + txtProdName.Text.Trim();
                    }
                    db.SaveChanges();
                    if (obj.IID == 0)
                    {
                        obj.IName = txtProdName.Text.Trim();
                        obj.Desc = txtDes.Text.Trim();
                        obj.OP_Qty = Convert.ToInt32(txtOpenQ.Text.DefaultZero());
                        obj.OP_Price = Convert.ToDouble(txtPurchase.Text.DefaultZero());
                        obj.PurPrice = Convert.ToDouble(txtPurchase.Text.DefaultZero());
                        obj.CompID = Convert.ToInt32(cmbxMak.SelectedValue);
                        obj.SCatID = Convert.ToInt32(cmbxCat.SelectedValue);
                        obj.Unit_ID = Convert.ToInt32(cmbcUni.SelectedValue);
                        obj.isDeleted = chkIsActive.Checked;
                        obj.RetailPrice = Convert.ToDouble(txtSale.Text.DefaultZero());
                        obj.SalesPrice = Convert.ToDouble(txtSale.Text.DefaultZero());
                        obj.DisR = Convert.ToDecimal(metroTextBox3.Text.DefaultZero());
                        obj.DisP = Convert.ToDecimal(txtDisP.Text.DefaultZero());
                        obj.CompanyID = compID;
                        obj.BarCode_ID = filename;
                        obj.CTN_PCK = Convert.ToInt32(txtpacking.Text.DefaultZero());
                        obj.ArticleNoID = Convert.ToInt32(cmbxArticle.SelectedValue);
                        obj.Color = Convert.ToInt32(cmbxColor.SelectedValue.DefaultZero()); //txtColor.Text;
                        obj.Size = Convert.ToInt32(cmbxSizes.SelectedValue.DefaultZero());
                        obj.BarcodeNo = txtBarCode.Text == "" ? GenerateRandomNo().ToString() : txtBarCode.Text;
                        obj.Inv_YN = chkNonInventory.Checked;
                        obj.AveragePrice = Convert.ToDouble(txtPurchase.Text.DefaultZero());
                        obj.Demand = Convert.ToDouble(txtDemand.Text.DefaultZero());
                        obj.ArticleTypeId = Convert.ToInt32(cmbxArticalType.SelectedValue.DefaultZero());
                        obj.Style = Convert.ToInt32(CmbxStylr.SelectedValue.DefaultZero());
                        obj.AC_Code_Cost = vals[1];
                        obj.AC_Code_Inc = vals[0];
                        obj.Img = Utillityfunctions.ToBase64(openFileDialog1.FileName, path + "\\Img\\" + filename);
                        obj.AC_Code_Inv = vals[2];
                        obj.Formula = txtFormula.Text;
                        obj.WholeSale = Convert.ToDecimal(txtWholeSale.Text.DefaultZero());
                        db.Items.Add(obj);
                    }
                    else
                    {
                        var result = db.Items.SingleOrDefault(b => b.IID == obj.IID);
                        if (result != null)
                        {
                            result.IName = txtProdName.Text.Trim();
                            result.Desc = txtDes.Text.Trim();
                            //   obj.OP_Qty = Convert.ToInt32(txtOpenQ.Text.DefaultZero());
                            //  obj.OP_Price = Convert.ToInt32(txtPurchase.Text.DefaultZero());
                            //  obj.PurPrice = Convert.ToInt32(txtPurchase.Text.DefaultZero());
                            result.CompID = Convert.ToInt32(cmbxMak.SelectedValue);
                            result.CompanyID = compID;
                            result.SCatID = Convert.ToInt32(cmbxCat.SelectedValue);
                            result.Unit_ID = Convert.ToInt32(cmbcUni.SelectedValue);
                            result.isDeleted = chkIsActive.Checked;
                            result.RetailPrice = Convert.ToDouble(txtPurchase.Text.DefaultZero());
                            result.SalesPrice = Convert.ToDouble(txtSale.Text.DefaultZero());
                            result.DisR = Convert.ToDecimal(metroTextBox3.Text.DefaultZero());
                            result.DisP = Convert.ToDecimal(txtDisP.Text.DefaultZero());
                            result.ArticleNoID = Convert.ToInt32(cmbxArticle.SelectedValue);
                            result.Color = Convert.ToInt32(cmbxColor.SelectedValue.DefaultZero());//txtColor.Text;
                            result.Size = Convert.ToInt32(cmbxSizes.SelectedValue.DefaultZero());
                            result.BarcodeNo = txtBarCode.Text == "" ? GenerateRandomNo().ToString() : txtBarCode.Text;
                            result.Inv_YN = chkNonInventory.Checked;
                            //  obj.AveragePrice = Convert.ToInt16(txtPurchase.Text.DefaultZero());
                            result.Demand = Convert.ToDouble(txtDemand.Text.DefaultZero());
                            result.ArticleTypeId = Convert.ToInt32(cmbxArticalType.SelectedValue.DefaultZero());
                            result.Style = Convert.ToInt32(CmbxStylr.SelectedValue.DefaultZero());
                            result.Formula = txtFormula.Text;
                            result.BarCode_ID = filename;
                            result.WholeSale = Convert.ToDecimal(txtWholeSale.Text.DefaultZero());
                            result.Img = Utillityfunctions.ToBase64(openFileDialog1.FileName, path + "\\Img\\" + filename);
                        }
                    }
                    db.SaveChanges();

                    var CheckLedger = db.Items.Where(x => x.Inv_YN == false && x.IID == obj.IID && x.CompanyID==compID).FirstOrDefault();
                    if (CheckLedger == null)
                    {

                    }

                    else
                    {
                        if (isAdd)
                        {

                            Itemledger itemledger = new Itemledger();
                            itemledger.EDate = System.DateTime.Now;
                            itemledger.AC_CODE = 12000001;
                            itemledger.WID = 1;
                            itemledger.SID = 1;
                            itemledger.IID = obj.IID;
                            itemledger.BNID = 1;
                            itemledger.TypeCode = 0;
                            itemledger.RID = 0;
                            itemledger.CompanyID = compID;
                            // itemledger.ExpDT = System.DateTime.Now;
                            itemledger.OPN = Convert.ToInt32(txtOpenQ.Text.DefaultZero());
                            itemledger.PurPrice = Convert.ToDouble(txtPurOPen.Text.DefaultZero());
                            itemledger.PAmt = Convert.ToDouble(txtOpenQ.Text.DefaultZero()) * Convert.ToDouble(txtPurOPen.Text.DefaultZero());
                            itemledger.Amt = Convert.ToDouble(txtOpenQ.Text.DefaultZero()) * Convert.ToDouble(txtPurOPen.Text.DefaultZero());
                            db.Itemledger.Add(itemledger);
                        }
                        else
                        {

                            //db.Itemledgers.RemoveRange(db.Itemledgers.Where(x => x.TypeCode == 0 && x.IID == obj.IID));

                            //Itemledger itemledger = new Itemledger();
                            //itemledger.EDate = System.DateTime.Now;
                            //itemledger.AC_CODE = 12000001;
                            //itemledger.WID = 1;
                            //itemledger.SID = 1;
                            //itemledger.IID = obj.IID;
                            //itemledger.BNID = 1;
                            //itemledger.TypeCode = 0;
                            //itemledger.RID = 0;
                            //// itemledger.ExpDT = System.DateTime.Now;
                            //itemledger.OPN = Convert.ToInt32(txtOpenQ.Text.DefaultZero());
                            //itemledger.PurPrice = Convert.ToDouble(txtPurOPen.Text.DefaultZero());
                            //itemledger.PAmt = Convert.ToDouble(txtOpenQ.Text.DefaultZero()) * Convert.ToDouble(txtPurOPen.Text.DefaultZero());
                            //itemledger.Amt = Convert.ToDouble(txtOpenQ.Text.DefaultZero()) * Convert.ToDouble(txtPurOPen.Text.DefaultZero());
                            //db.Itemledgers.Add(itemledger);


                        }
                        db.SaveChanges();
                    }


                    pnlMain.Hide();
                    list = db.Items.AsNoTracking().Where(x => x.CompanyID == compID).ToList();
                    ProdBindingSource.DataSource = list;

                }

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        private void PartyTypeDataGridView_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            ProductsDataGridView.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
        }


        public void FillCombo(ComboBox comboBox, object obj, String Name, String ID, int selected = 1)
        {
            try
            {
                comboBox.DataSource = obj;
                comboBox.DisplayMember = Name; // Column Name
                comboBox.ValueMember = ID;  // Column Name
                comboBox.SelectedValue = selected;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void toolStripTextBoxFind_Leave(object sender, EventArgs e)
        {
            try
            {
                if (toolStripTextBoxFind.Text.Trim().Length == 0) { ProductsDataGridView.DataSource = list; }
                else
                {
                    ProductsDataGridView.DataSource = list.FindAll(x => x.IName.ToLower().Contains(toolStripTextBoxFind.Text.ToLower().Trim()));
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        private void txtDebit_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar) &&
        (e.KeyChar != '.'))
            {
                e.Handled = true;
            }

            // only allow one decimal point
            if ((e.KeyChar == '.') && ((sender as MetroFramework.Controls.MetroTextBox).Text.IndexOf('.') > -1))
            {
                e.Handled = true;
            }
        }

        private void txtCredit_KeyPress(object sender, KeyPressEventArgs e)
        {

            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar) &&
        (e.KeyChar != '.'))
            {
                e.Handled = true;
            }

            // only allow one decimal point
            if ((e.KeyChar == '.') && ((sender as MetroFramework.Controls.MetroTextBox).Text.IndexOf('.') > -1))
            {
                e.Handled = true;
            }
        }

        private void metroButton1_Click(object sender, EventArgs e)
        {

            openFileDialog1.InitialDirectory = "C://Desktop";
            openFileDialog1.Title = "Select image to be upload.";
            openFileDialog1.Filter = "Image Only(*.jpg; *.jpeg; *.gif; *.bmp; *.png)|*.jpg; *.jpeg; *.gif; *.bmp; *.png";
            openFileDialog1.FilterIndex = 1;
            try
            {
                if (openFileDialog1.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                {
                    if (openFileDialog1.CheckFileExists)
                    {
                        string path = System.IO.Path.GetFullPath(openFileDialog1.FileName);
                        label21.Text = openFileDialog1.FileName;
                        pictureBox1.Image = new Bitmap(openFileDialog1.FileName);
                        pictureBox1.SizeMode = PictureBoxSizeMode.StretchImage;
                    }
                }
                else
                {
                    MessageBox.Show("Please Upload image.");
                }
            }
            catch (Exception ex)
            {
                //it will give if file is already exits..
                MessageBox.Show(ex.Message);
            }
        }

        private void panel1_Paint(object sender, PaintEventArgs e)
        {

        }
    }
}
