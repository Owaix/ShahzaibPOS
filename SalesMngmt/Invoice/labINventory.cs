﻿using Lib;
using Lib.Entity;
using Lib.Model;
using SalesMngmt.Configs;
using SalesMngmt.Utility;
using System;
using SnaksalesERP;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Linq;
using System.Windows.Forms;
using Microsoft.Reporting.WinForms;
using Lib.Utilities;
using System.Data;


namespace SalesMngmt.Invoice
{
    public partial class labINventory : MetroFramework.Forms.MetroForm
    {
        SaleManagerEntities db = null;
        List<Lib.Entity.Items> listItems = null;
        int compID = 0;
        List<tblStock> stock = null;
        public labINventory SInvoice { get; set; }
        public labINventory(int Company)
        {
            InitializeComponent();
            db = new SaleManagerEntities();
            compID = Company;
            SInvoice = this;
            stock = new List<tblStock>();
            listItems = db.Items.ToList();
        }

        private int ItemID()
        {
            var itemID = cmbxItems.Text;
            var items = listItems.Where(x => x.IName.ToLower().Trim().Contains(cmbxItems.Text.ToLower().Trim())).FirstOrDefault();
            if (items != null)
            {
                return items.IID;
            }
            return 0;
        }

        private int ItemID(int ItemID)
        {
            var itemID = cmbxItems.Text;
            var items = listItems.Where(x => x.IID == ItemID).FirstOrDefault();
            if (items != null)
            {
                return items.IID;
            }
            return 0;
        }

        private void SInv_Load(object sender, EventArgs e)
        {
            //account headr
            List<COA_M> article = new List<COA_M>();
            article.Add(new COA_M { CAC_Code = 0, CATitle = "--SELECT--" });
            article.AddRange(db.COA_M.Where(x => x.CAC_Code == 1 || x.CAC_Code == 3 || x.CAC_Code == 9).ToList());

            FillCombo(cmbxAccID, article, "CATitle", "CAC_Code", 0);


            //parties
            List<COA_D> parties = new List<COA_D>();
            parties.Add(new COA_D { AC_Code = 0, AC_Title = "--Select--" });
            parties.AddRange(db.COA_D.Where(x => x.CAC_Code == 1).ToList());
            //   var vendor = ;
            FillCombo(cmbxvendor, parties, "AC_Title", "AC_Code", 0);

            ////account headr
            //article.Add(new Article { ProductID = 0, ArticleNo = "--SELECT--" });
            //article.AddRange(db.Articles.ToList());
            //var Account = db.COA_M.Where(x => x.CAC_Code == 1 || x.CAC_Code == 3 || x.CAC_Code == 9).ToList();
            //FillCombo(cmbxAccID, Account, "CATitle", "CAC_Code", 0);

            //payment mode
            List<COA_D> cash = new List<COA_D>();
            cash.Add(new COA_D { AC_Code = 0, AC_Title = "--Credit--" });
            cash.AddRange(db.COA_D.Where(x => x.CAC_Code == 1).ToList());
            FillCombo(cmbxPaymentMode, cash, "AC_Title", "AC_Code", 0);

            List<Lib.Entity.Items> Items = new List<Lib.Entity.Items>();
            Items.Add(new Lib.Entity.Items { IID = 0, IName = "--SELECT--" });
            Items.AddRange(db.Items.Where(x => x.CompanyID == compID).ToList());
            //    var vendor = db.Customers.Where(x => x.CompanyID == compID).ToList();
            //   var vendorAcode = db.Customers.Where(x => x.CompanyID == compID).FirstOrDefault();


            ////parties
            //List<COA_D> parties = new List<COA_D>();
            //parties.Add(new COA_D { AC_Code = 0, AC_Title = "--Select--" });
            //var vendor = db.COA_D.Where(x => x.CAC_Code == 1).ToList();
            //FillCombo(cmbxvendor, vendor, "AC_Title", "AC_Code", 0);


            //  FillCombo(cmbxAccID, vendor, "AC_Code", "AC_Code", 0);
            // FillCombo(cmbxvendor, vendor, "CusName", "AC_Code", 0);
            //   cmbxvendor.SelectedValue = vendorAcode.AC_Code;
            // cmbxAccID.SelectedValue = vendorAcode.AC_Code;

            lblRID.Text = "0";
        }

        private void metroTextBox1_Leave(object sender, EventArgs e)
        {
            var dsa = txtCode.Text;
            if (dsa != "")
            {
                var items = listItems.Where(x => x.BarcodeNo == dsa).FirstOrDefault();
                if (items != null)
                {
                    txtRate.Text = items.SalesPrice.ToString();
                }
            }

            //else
            //{
            //    MessageBox.Show("Invalid Barcode");
            //    txtCode.Focus();
            //}
        }

        private void metroPanel4_Paint(object sender, System.Windows.Forms.PaintEventArgs e)
        {

        }

        public void FillCombo<T>(ComboBox comboBox, IEnumerable<T> obj, String Name, String ID, int selected = 0)
        {
            try
            {
                if (obj.Count() > 0)
                {
                    comboBox.DataSource = obj;
                    comboBox.DisplayMember = Name; // Column Name
                    comboBox.ValueMember = ID;  // Column Name
                    comboBox.SelectedIndex = selected;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void cmbxItems_Leave(object sender, EventArgs e)
        {

        }

        //private void AddIntoGrid()
        //{
        //    var isAdd = true;

        //    var iid = Convert.ToInt32(cmbxItems.SelectedValue);
        //    var item = db.Items.Where(x => x.IID == iid).FirstOrDefault();
        //    if (item != null)
        //    {
        //        var totalCTn = item.CTN_PCK * Convert.ToInt32(txtctn.Text.DefaultZero());
        //        var TotalPcs = totalCTn + Convert.ToInt32(txtpcs.Text);
        //        foreach (DataGridViewRow row in invGrid.Rows)
        //        {
        //            if (row.Cells[0].Value != null)
        //            {
        //                var itemID = Convert.ToInt32(row.Cells[0].Value.DefaultZero());
        //                if (Convert.ToInt32(cmbxItems.SelectedValue) == itemID)
        //                {
        //                    var PcsRate = Convert.ToDouble(txtRate.Text.DefaultZero()) * TotalPcs;
        //                    var NetAmount = PcsRate - Convert.ToDouble(txtDisc.Text.DefaultZero());
        //                    NetAmount = NetAmount * Convert.ToDouble(txtDisPer.Text.DefaultZero() == "0" ? "1" : "0." + txtDisPer.Text);
        //                    row.Cells[2].Value = txtctn.Text.DefaultZero();
        //                    row.Cells[3].Value = Convert.ToInt16(row.Cells[3].Value) + Convert.ToInt16(txtpcs.Text.DefaultZero());
        //                    row.Cells[4].Value = txtRate.Text.DefaultZero();
        //                    row.Cells[5].Value = String.Format("{0:0.00}", PcsRate).DefaultZero();
        //                    row.Cells[6].Value = txtDisPer.Text.DefaultZero();
        //                    row.Cells[7].Value = txtDisc.Text.DefaultZero();
        //                    row.Cells[8].Value = String.Format("{0:0.00}", NetAmount).DefaultZero();
        //                    row.Cells[9].Value = txtSaleP.Text.DefaultZero();
        //                    row.Cells["SaleRate"].Value = txtSaleRate.Text.DefaultZero();
        //                    isAdd = false;
        //                }
        //            }
        //        }
        //        if (isAdd == true)
        //        {
        //            this.invGrid.Rows.Add(cmbxItems.SelectedValue,
        //                cmbxItems.Text,
        //                txtctn.Text.DefaultZero(),
        //                txtpcs.Text.DefaultZero(),
        //                txtRate.Text.DefaultZero(),
        //                String.Format("{0:0.00}", PcsRate).DefaultZero(),
        //                txtDisPer.Text.DefaultZero(), txtDisc.Text.DefaultZero(),
        //                String.Format("{0:0.00}", NetAmount).DefaultZero(),
        //                txtSaleP.Text.DefaultZero(),
        //                txtSaleRate.Text.DefaultZero());
        //        }

        //        invGrid_SelectionChanged(null, null);
        //        clear(true);
        //    }
        //}
        //Replace into Process Cmd
        private void metroButton1_Click(object sender, EventArgs e)
        {
            var isAdd = true;
            if (ItemID() == 0)
            {
                MessageBox.Show("Item is Required", "Required", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                cmbxItems.Focus();
                return;
            }
            if (txtpcs.Text == "")
            {
                MessageBox.Show("Pieces is Required", "Required", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                cmbxItems.Focus();
                return;
            }
            var iid = ItemID();
            var check123 = txtCode.Text;
            var item = db.Items.Where(x => x.IID == iid).FirstOrDefault();
            if (item != null)
            {
                // var totalCTn = item.CTN_PCK * Convert.ToInt32(txtctn.Text.DefaultZero());
                //var TotalPcs = totalCTn + Convert.ToInt32(txtpcs.Text); // -->
                //var PcsRate = Convert.ToDouble(txtRate.Text.DefaultZero()) * TotalPcs;
                //var NetAmount = PcsRate - Convert.ToDouble(txtDisc.Text.DefaultZero());
                //   NetAmount = NetAmount * Convert.ToDouble(txtDisPer.Text.DefaultZero() == "0" ? "1" : "0." + txtDisPer.Text);

                foreach (DataGridViewRow row in invGrid.Rows)
                {
                    if (row.Cells[0].Value != null)
                    {
                        var itemID = Convert.ToInt32(row.Cells[0].Value.DefaultZero());
                        var stockid = db.getStockByID(itemID).FirstOrDefault();
                        if (ItemID() == itemID)
                        {
                            row.Cells[2].Value = txtctn.Text.DefaultZero();
                            if (txtCode.Text != "")
                            {
                                txtpcs.Text = (Convert.ToDouble(row.Cells[3].Value) + Convert.ToDouble(1)).ToString();
                                double value = Convert.ToDouble(txtpcs.Text);
                                double ctn;
                                if (Convert.ToDouble(item.CTN_PCK.DefaultZero()) == 0)
                                {
                                    ctn = (Convert.ToDouble(txtctn.Text.DefaultZero()));
                                }
                                else
                                {
                                    ctn = (Convert.ToDouble(txtctn.Text.DefaultZero()) * Convert.ToDouble(item.CTN_PCK.DefaultZero()));
                                }
                                //  ctn = (Convert.ToDouble(txtctn.Text.DefaultZero()) * Convert.ToDouble(item.CTN_PCK.DefaultZero()));
                                value += ctn;
                                calculation();
                                //if (stockid >= value)
                                //{


                                //}
                                if (item.Inv_YN == true)
                                {
                                    row.Cells[0].Value = ItemID();
                                    row.Cells[1].Value = cmbxItems.Text;
                                    row.Cells[2].Value = txtctn.Text.DefaultZero();
                                    row.Cells[3].Value = txtpcs.Text.DefaultZero();
                                    row.Cells[4].Value = txtRate.Text.DefaultZero();
                                    row.Cells[5].Value = txtSaleP.Text.DefaultZero();
                                    row.Cells[6].Value = txtDisPer.Text.DefaultZero();
                                    row.Cells[7].Value = txtDisc.Text.DefaultZero();
                                    row.Cells[8].Value = txtNet.Text.DefaultZero();
                                    row.Cells[9].Value = txtPcsRate.Text.DefaultZero();
                                    row.Cells[10].Value = txtSaleRate.Text.DefaultZero();

                                }
                                else
                                {
                                    row.Cells[0].Value = ItemID();
                                    row.Cells[1].Value = cmbxItems.Text;
                                    row.Cells[2].Value = txtctn.Text.DefaultZero();
                                    row.Cells[3].Value = txtpcs.Text.DefaultZero();
                                    row.Cells[4].Value = txtRate.Text.DefaultZero();
                                    row.Cells[5].Value = txtSaleP.Text.DefaultZero();
                                    row.Cells[6].Value = txtDisPer.Text.DefaultZero();
                                    row.Cells[7].Value = txtDisc.Text.DefaultZero();
                                    row.Cells[8].Value = txtNet.Text.DefaultZero();
                                    row.Cells[9].Value = txtPcsRate.Text.DefaultZero();
                                    row.Cells[10].Value = txtSaleRate.Text.DefaultZero();
                                }
                            }
                            else
                            {
                                calculation();
                                double value = Convert.ToDouble(txtpcs.Text);
                                double ctn = (Convert.ToDouble(txtctn.Text.DefaultZero()) * Convert.ToDouble(item.CTN_PCK.DefaultZero()));
                                value += ctn;
                                //if (stockid >= value)
                                //{


                                // }
                                if (item.Inv_YN == true)
                                {
                                    row.Cells[0].Value = ItemID();
                                    row.Cells[1].Value = cmbxItems.Text;
                                    row.Cells[2].Value = txtctn.Text.DefaultZero();
                                    row.Cells[3].Value = txtpcs.Text.DefaultZero();
                                    row.Cells[4].Value = txtRate.Text.DefaultZero();
                                    row.Cells[5].Value = txtSaleP.Text.DefaultZero();
                                    row.Cells[6].Value = txtDisPer.Text.DefaultZero();
                                    row.Cells[7].Value = txtDisc.Text.DefaultZero();
                                    row.Cells[8].Value = txtNet.Text.DefaultZero();
                                    row.Cells[9].Value = txtPcsRate.Text.DefaultZero();
                                    row.Cells[10].Value = txtSaleRate.Text.DefaultZero();

                                }
                                else
                                {
                                    row.Cells[0].Value = ItemID();
                                    row.Cells[1].Value = cmbxItems.Text;
                                    row.Cells[2].Value = txtctn.Text.DefaultZero();
                                    row.Cells[3].Value = txtpcs.Text.DefaultZero();
                                    row.Cells[4].Value = txtRate.Text.DefaultZero();
                                    row.Cells[5].Value = txtSaleP.Text.DefaultZero();
                                    row.Cells[6].Value = txtDisPer.Text.DefaultZero();
                                    row.Cells[7].Value = txtDisc.Text.DefaultZero();
                                    row.Cells[8].Value = txtNet.Text.DefaultZero();
                                    row.Cells[9].Value = txtPcsRate.Text.DefaultZero();
                                    row.Cells[10].Value = txtSaleRate.Text.DefaultZero();
                                }
                            }

                            //      row.Cells[4].Value = txtRate.Text.DefaultZero();

                            //      row.Cells[6].Value = txtDisPer.Text.DefaultZero();
                            //      row.Cells[7].Value = txtDisc.Text.DefaultZero();
                            ////-->
                            //      row.Cells[9].Value = txtSaleP.Text.DefaultZero();
                            //      row.Cells["SaleRate"].Value = txtSaleRate.Text.DefaultZero();
                            isAdd = false;
                        }
                    }
                }
                if (isAdd == true)
                {
                    calculation();

                    var stockid = db.getStockByID(item.IID).FirstOrDefault();
                    double value = Convert.ToDouble(txtpcs.Text);
                    double ctn = (Convert.ToDouble(txtctn.Text.DefaultZero() == "0" ? "1" : txtctn.Text.DefaultZero()) * Convert.ToDouble(item.CTN_PCK.DefaultZero()));
                    value += ctn;
                    //if (stockid >= value)
                    //{

                    //}
                    if (item.Inv_YN == true)
                    {

                        this.invGrid.Rows.Add(ItemID(),
                        cmbxItems.Text,
                        txtctn.Text.DefaultZero(),
                        txtpcs.Text.DefaultZero(),
                        txtRate.Text.DefaultZero(),
                        txtSaleP.Text.DefaultZero(),
                        txtDisPer.Text.DefaultZero(),
                        txtDisc.Text.DefaultZero(),
                        txtNet.Text.DefaultZero(),
                        txtPcsRate.Text.DefaultZero(),
                        txtSaleRate.Text.DefaultZero(),
                        "Remove",
                       "0");

                        invGrid_SelectionChanged(null, null);
                        clear(true);

                    }
                    else
                    {

                        this.invGrid.Rows.Add(ItemID(),
                      cmbxItems.Text,
                      txtctn.Text.DefaultZero(),
                      txtpcs.Text.DefaultZero(),
                      txtRate.Text.DefaultZero(),
                      txtSaleP.Text.DefaultZero(),
                      txtDisPer.Text.DefaultZero(),
                      txtDisc.Text.DefaultZero(),
                      txtNet.Text.DefaultZero(),
                      txtPcsRate.Text.DefaultZero(),
                      txtSaleRate.Text.DefaultZero(),
                      "Remove", "0");


                        invGrid_SelectionChanged(null, null);
                        clear(true);
                        //MessageBox.Show("stock can,t be more than that " + stockid);
                        //return;
                    }
                }

                invGrid_SelectionChanged(null, null);
                calculation();
                txtCode.Focus();
            }
        }

        private void invGrid_SelectionChanged(object sender, EventArgs e)
        {
            Decimal totalAmount = 0;
            foreach (DataGridViewRow row in invGrid.Rows)
            {
                if (row.Cells[0].Value != null)
                {
                    lblItemID.Text = row.Cells[0].Value.DefaultZero();
                    txtctn.Text = row.Cells[2].Value.ToString();
                    txtpcs.Text = row.Cells[3].Value.ToString();
                    txtRate.Text = row.Cells[4].Value.ToString();
                    txtDisPer.Text = (row.Cells[6].Value ?? "0").ToString();
                    txtDisc.Text = (row.Cells[7].Value ?? "0").ToString();
                    txtSaleP.Text = (row.Cells[9].Value ?? "0").ToString();
                    totalAmount += Convert.ToDecimal(row.Cells["netAm"].Value.DefaultZero());
                    txtNet.Text = totalAmount.ToString();
                }
            }
            txtDisfooter.Text = txtDisfooter.Text.DefaultZero();
            txtTotalAm.Text = totalAmount.ToString();
            txtNetAm.Text = (Convert.ToDecimal(txtTotalAm.Text) - Convert.ToDecimal(txtDisfooter.Text)).ToString();
        }

        private void txtPartyType_Leave(object sender, EventArgs e)
        {

        }

        public void SetInvID(String InvID)
        {
            lblInvN.Text = InvID;
            lblInvN.Visible = true;
            lblInvHeader.Visible = true;
            //txtInv.Enabled = false;
        }

        public void EditInv(string invNo)
        {
            clear();
            var Master = db.Sales_M.Where(x => x.InvNo == invNo).FirstOrDefault();
            if (Master != null)
            {
                lblRID.Text = Master.RID.ToString();
                txtNetAm.Text = Master.NetAmt.ToString();
                txtDisfooter.Text = Master.DisAmt;
                txtTotalAm.Text = Master.TotalAmount.ToString();
                txtRemarks.Text = Master.Rem.ToString();
                cmbxAccID.SelectedValue = Convert.ToInt32(Master.AC_Code);
                cmbxvendor.SelectedValue = Convert.ToInt32(Master.AC_Code);
                txtbilty.Text = Master.BiltyNo;
                txtInv.Text = Master.CstInvNo;
                txtInvDate.Text = Master.VenInvDate;

                var Detail = db.Sales_D.Where(x => x.RID == Master.RID).ToList();
                foreach (var item in Detail)
                {
                    var itemName = db.Items.Where(x => x.IID == item.IID).FirstOrDefault();
                    if (itemName != null)
                    {

                        var TotalPcs = (item.Qty * item.SalesPriceP);
                        var PcsRate = Convert.ToDouble(item.SalesPriceP) * TotalPcs;
                        var NetAmount = PcsRate - Convert.ToDouble(item.DisRs);
                        txtDisPer.Text = txtDisPer.Text ?? "0";
                        // NetAmount = NetAmount * Convert.ToDouble(item.DisP == "0" ? "1" : "0." + item.DisP);



                        this.invGrid.Rows.Add(item.IID, itemName.IName, item.CTN, item.PCS, item.SalesPriceP, TotalPcs, item.DisP, item.DisRs, item.Amt, "", "", "Remove", itemName.ArticleNoID);
                        invGrid_SelectionChanged(null, null);
                    }
                }
            }
        }

        private void invGrid_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                var senderGrid = (DataGridView)sender;
                if (senderGrid.Columns[e.ColumnIndex] is DataGridViewButtonColumn && e.RowIndex >= 0)
                {
                    if (e.ColumnIndex == 11)
                    {
                        invGrid.Rows.RemoveAt(e.RowIndex);
                        invGrid_SelectionChanged(null, null);
                    }
                    else
                    {
                        var ItemID = Convert.ToInt32(invGrid.Rows[e.RowIndex].Cells[0].Value);
                        var items = db.Items.Where(x => x.IID == ItemID).FirstOrDefault();
                        items.SalesPrice = Convert.ToDouble(invGrid.Rows[e.RowIndex].Cells[9].Value.DefaultZero());
                        db.Entry(items).State = EntityState.Modified;
                        db.SaveChanges();
                        MessageBox.Show("Item Sale Price Updated", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                }
                else if (senderGrid.Columns[e.ColumnIndex] is DataGridViewCheckBoxColumn)
                {
                    DataGridViewCheckBoxCell ch1 = new DataGridViewCheckBoxCell();
                    ch1 = (DataGridViewCheckBoxCell)invGrid.Rows[invGrid.CurrentRow.Index].Cells[e.ColumnIndex];

                    if (ch1.Value == null)
                        ch1.Value = false;
                    switch (ch1.Value.ToString())
                    {
                        case "True":
                            ch1.Value = false;
                            break;
                        case "False":
                            ch1.Value = true;
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Please Try Again", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void txtDis_TextChanged(object sender, EventArgs e)
        {
            txtNetAm.Text = (Convert.ToDouble(txtTotalAm.Text.DefaultZero()) + Convert.ToDouble(txtTransportExpense.Text.DefaultZero()) - Convert.ToDouble(txtDisfooter.Text.DefaultZero())).ToString();

        }

        private void txtCredit_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar) && (e.KeyChar != '.'))
            {
                e.Handled = true;
            }

            // only allow one decimal point
            if ((e.KeyChar == '.') && ((sender as MetroFramework.Controls.MetroTextBox).Text.IndexOf('.') > -1))
            {
                e.Handled = true;
            }
        }

        private void invGrid_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e != null && e.RowIndex > -1)
            {
                lblItemID.Text = invGrid.Rows[e.RowIndex].Cells[0].Value.DefaultZero();
                cmbxItems.Text = invGrid.Rows[e.RowIndex].Cells[1].Value.ToString();
                txtctn.Text = invGrid.Rows[e.RowIndex].Cells[2].Value.DefaultZero();
                txtpcs.Text = invGrid.Rows[e.RowIndex].Cells[3].Value.DefaultZero();
                txtRate.Text = invGrid.Rows[e.RowIndex].Cells[4].Value.DefaultZero();
                txtDisPer.Text = invGrid.Rows[e.RowIndex].Cells[6].Value.DefaultZero();
                txtDisc.Text = invGrid.Rows[e.RowIndex].Cells[7].Value.DefaultZero();
                txtNet.Text = invGrid.Rows[e.RowIndex].Cells[8].Value.DefaultZero();
                txtSaleP.Text = invGrid.Rows[e.RowIndex].Cells[9].Value.DefaultZero();
                txtRate_Leave(null, null);
                txtSaleP_Leave(null, null);
            }
        }

        private void metroButton2_Click(object sender, EventArgs e)
        {
            clear();
        }

        private void clear(bool grid = false)
        {
            txtInv.Enabled = true;
            txtInv.Text = "";
            txtCode.Text = "";

            cmbxItems.Text = "";
            txtCode.Focus();
            if (grid == false)
            {
                //var vendorAcode = db.Customers.Where(x => x.CompanyID == compID).FirstOrDefault();
                //cmbxvendor.SelectedIndex = vendorAcode.AC_Code;
                //cmbxAccID.SelectedIndex = vendorAcode.AC_Code;
                //invGrid.DataSource = null;
                invGrid.Rows.Clear();
                txtNetAm.Text = "0";
                txtSaleP.Text = "0";
                txtTotalAm.Text = "0";
                txtDisfooter.Text = "0";
                lblRID.Text = "0";
                lblInvN.Visible = false;
                lblInvHeader.Visible = false;
                txtInv.Focus();
            }
            txtDisc.Text = "0";
            txtDisPer.Text = "0";
            txtctn.Text = "0";
            txtpcs.Text = "0";
            txtbilty.Text = "0";
            txtRate.Text = "0";
            txtNet.Text = "0";
            txtPcsRate.Text = "0";
            txtSaleRate.Text = "0";
            dataGridView1.Visible = false;
            panel1.Visible = false;
            txtSaleP.Text = "0";
        }

        private void metroButton3_Click(object sender, EventArgs e)
        {
            SaveRecord(lblRID.Text);
        }

        private void metroButton4_Click(object sender, EventArgs e)
        {
            SaveRecord(lblRID.Text);
        }

        private void SInv_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.F && e.Modifiers == Keys.Alt)
            {
                clear();
            }
        }

        private void SaveRecord(String InvoiceNo)
        {
            if (invGrid.Rows.Count == 0)
            {
                MessageBox.Show("Please Add Items In Grid", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            int vebdorid = Convert.ToInt32(cmbxvendor.SelectedValue);
            if (vebdorid == 0 || vebdorid == null)
            {
                MessageBox.Show("Please select AccountName", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                cmbxvendor.Focus();
                return;
            }
            Lab_M sale = null;
            DbContextTransaction transaction = db.Database.BeginTransaction();
            try
            {
                if (InvoiceNo == "0")
                {
                    sale = new Lab_M();
                    DataAccess access = new DataAccess();
                    Purc_M coa = new Purc_M();
                    coa.InvType = "Lab";
                    SqlConnection con = new SqlConnection(ConnectionStrings.GetCS);
                    con.Open();
                    SqlTransaction trans = con.BeginTransaction();

                    sale.InvNo = access.GetScalar("Gen_NewInvNoSale", coa, con, trans);
                    sale.InvDT = DateTime.Now;
                }
                else
                {
                    var RID = Convert.ToInt32(InvoiceNo);
                    sale = db.Lab_M.Where(x => x.RID == RID).FirstOrDefault();
                    sale.Edit_Date = DateTime.Now;
                }

                sale.InvType = "Lab";
                sale.EDate = DateTime.Now;
                sale.AC_Code = Convert.ToInt32(cmbxvendor.SelectedValue);
                sale.WID = 1;
                sale.TotalAmount = Convert.ToDecimal(txtTotalAm.Text);
                sale.DisAmt = txtDisfooter.Text;
                sale.NetAmt = Convert.ToDouble(txtTotalAm.Text);
                sale.BiltyNo = txtbilty.Text;
                sale.Rem = txtRemarks.Text;
                sale.CompID = compID;
                sale.CstInvNo = txtInv.Text;
                sale.VenInvDate = txtInvDate.Text;
                sale.TransportExpense = Convert.ToDouble(txtTransportExpense.Text.DefaultZero());
                if (InvoiceNo == "0")
                {
                    db.Lab_M.Add(sale);
                }
                db.SaveChanges();
                if (InvoiceNo != "0")
                {
                    db.Entry(sale).State = EntityState.Modified;
                    db.Sales_D.RemoveRange(db.Sales_D.Where(x => x.RID == sale.RID));
                    db.Itemledger.RemoveRange(db.Itemledger.Where(x => x.RID == sale.RID));
                    db.GL.RemoveRange(db.GL.Where(x => x.RID == sale.RID));
                }

                foreach (DataGridViewRow row in invGrid.Rows)
                {
                    if (row.Cells[0].Value != null)
                    {
                        int id = Convert.ToInt32(row.Cells[0].Value);
                        var item = db.Items.Where(x => x.IID == id).FirstOrDefault();

                        Lab_D detail = new Lab_D();
                        detail.RID = sale.RID;
                        detail.IID = Convert.ToDouble(row.Cells[0].Value.ToString().DefaultZero());
                        detail.CTN = row.Cells[2].Value.ToString().DefaultZero();
                        detail.PCS = Convert.ToDouble(row.Cells[3].Value.ToString().DefaultZero());
                        detail.PurPrice = Convert.ToDouble(item.AveragePrice.DefaultZero());
                        detail.DisP = (row.Cells[6].Value ?? "0").ToString();
                        detail.DisRs = (row.Cells[7].Value ?? "0").ToString();

                        double ctn;
                        if (Convert.ToInt32(item.CTN_PCK.DefaultZero()) == 0)
                        {
                            ctn = Convert.ToDouble(row.Cells[2].Value.DefaultZero());

                        }
                        else
                        {

                            ctn = Convert.ToDouble(item.CTN_PCK.DefaultZero()) * Convert.ToDouble(row.Cells[2].Value.DefaultZero());
                        }


                        detail.SalesPriceP = Convert.ToDouble(row.Cells[4].Value.ToString().DefaultZero());
                        detail.Qty = ctn + Convert.ToDouble(row.Cells[3].Value);
                        detail.DisAmt = Convert.ToDouble(Convert.ToDouble(row.Cells[6].Value.DefaultZero()) / 100 * Convert.ToDouble(row.Cells[5].Value.DefaultZero())).ToString();//Convert.ToDouble(txtSaleRate.Text);
                        //BatchNo BAtchNO
                        //Quantity Caton+Pices
                        detail.Amt = Convert.ToDouble(row.Cells[8].Value.ToString().DefaultZero());
                        detail.Amt2 = Convert.ToDouble(item.AveragePrice.DefaultZero()) * detail.Qty;
                        //DisAmount   percentage in rupess
                        //Amt         after complete discount
                        db.Lab_D.Add(detail);
                        db.SaveChanges();
                        int Ridid = Convert.ToInt32(row.Cells[0].Value.DefaultZero());
                        var checkstock = db.Items.Where(x => x.IID == Ridid).FirstOrDefault();
                        if (checkstock.Inv_YN == false)
                        {
                            Itemledger ledger = new Itemledger();
                            ledger.RID = sale.RID;
                            ledger.IID = Convert.ToInt32(row.Cells[0].Value.DefaultZero());
                            ledger.EDate = DateTime.Now;
                            // ledger.Bnid = BatchNo
                            ledger.TypeCode = 26;
                            ledger.AC_CODE = Convert.ToInt32(cmbxvendor.SelectedValue);
                            ledger.WID = 1;
                            // ledger.SiD =
                            //    var ctnledger = Convert.ToDouble(item.CTN_PCK.DefaultZero()) * Convert.ToDouble(row.Cells[2].Value.DefaultZero());
                            ledger.CTN = Convert.ToInt32(row.Cells[2].Value.ToString());
                            ledger.PCS = Convert.ToInt32(row.Cells[3].Value.ToString());
                            ledger.SJ = ctn + Convert.ToInt32(row.Cells[3].Value);
                            ledger.PurPrice = Convert.ToDouble(item.AveragePrice.DefaultZero());
                            ledger.SalesPriceP = Convert.ToInt32(row.Cells[4].Value.ToString());//  ledger.Pamt = TotalAmount(pj * PurPrice)
                            ledger.DisP = Convert.ToDouble(row.Cells[6].Value.DefaultZero());
                            //ledger.DisAmount = percentage in rupess
                            ledger.DisRs = Convert.ToDouble(row.Cells[7].Value.DefaultZero());
                            ledger.Amt = Convert.ToDouble(row.Cells[8].Value.DefaultZero());
                            ledger.DisAmt = Convert.ToDouble(Convert.ToDouble(row.Cells[6].Value.DefaultZero()) / 100 * Convert.ToDouble(row.Cells[5].Value.DefaultZero()));//Convert.ToDouble(txtSaleRate.Text);
                            db.Itemledger.Add(ledger);
                            db.SaveChanges();

                            GL gl = new GL();
                            gl.RID = sale.RID;
                            gl.TypeCode = 26;
                            gl.GLDate = DateTime.Now;
                            gl.IPrice = Convert.ToDouble(row.Cells[4].Value.DefaultZero());
                            gl.AC_Code = Convert.ToInt32(cmbxvendor.SelectedValue);
                            gl.AC_Code2 = item.AC_Code_Inv;
                            gl.Narration = row.Cells[1].Value.ToString();
                            //  gl.MOP_ID = 2;
                            gl.Qty_Out = ctn + Convert.ToInt32(row.Cells[3].Value);
                            gl.PAmt = Convert.ToDouble(row.Cells[5].Value.DefaultZero());
                            gl.DisP = Convert.ToDouble(row.Cells[6].Value ?? "0");
                            gl.DisRs = Convert.ToDouble((row.Cells[7].Value ?? "0"));
                            gl.DisAmt = Convert.ToDouble(Convert.ToDouble(row.Cells[6].Value.DefaultZero()) / 100 * Convert.ToDouble(row.Cells[5].Value.DefaultZero()));//Convert.ToDouble(txtSaleRate.Text);
                            gl.Debit = Convert.ToDouble(row.Cells[8].Value.DefaultZero());
                            gl.Credit = 0;
                            db.GL.Add(gl);
                            db.SaveChanges();

                            GL gl1 = new GL();
                            gl1.RID = sale.RID;
                            gl1.TypeCode = 26;
                            gl1.GLDate = DateTime.Now;
                            gl1.IPrice = item.AveragePrice;
                            gl1.AC_Code = item.AC_Code_Inv;
                            gl1.AC_Code2 = Convert.ToInt32(cmbxvendor.SelectedValue);
                            gl1.Narration = cmbxvendor.SelectedText;
                            //  gl.MOP_ID = 2;
                            gl1.Qty_Out = ctn + Convert.ToInt32(row.Cells[3].Value);
                            gl1.PAmt = Convert.ToDouble(item.AveragePrice.DefaultZero()) * (ctn + Convert.ToInt32(row.Cells[3].Value));//Convert.ToDouble(row.Cells[5].Value.DefaultZero());
                            gl1.DisP = 0;// Convert.ToDouble(row.Cells[6].Value ?? "0");
                            gl1.DisRs = 0; //Convert.ToDouble((row.Cells[7].Value ?? "0"));
                            gl1.DisAmt = 0;// Convert.ToDouble(Convert.ToDouble(row.Cells[6].Value.DefaultZero()) / 100 * Convert.ToDouble(row.Cells[5].Value.DefaultZero()));//Convert.ToDouble(txtSaleRate.Text);
                            gl1.Debit = 0;
                            gl1.Credit = Convert.ToDouble(item.AveragePrice.DefaultZero()) * (ctn + Convert.ToInt32(row.Cells[3].Value));
                            db.GL.Add(gl1);
                            db.SaveChanges();


                            GL gl2 = new GL();
                            gl2.RID = sale.RID;
                            gl2.TypeCode = 26;
                            gl2.GLDate = DateTime.Now;
                            gl2.IPrice = Convert.ToDouble(row.Cells[4].Value.DefaultZero());
                            gl2.AC_Code = item.AC_Code_Inc;
                            gl2.AC_Code2 = Convert.ToInt32(cmbxvendor.SelectedValue);
                            gl2.Narration = cmbxvendor.SelectedText;
                            //  gl.MOP_ID = 2;
                            gl2.Qty_Out = ctn + Convert.ToInt32(row.Cells[3].Value);
                            gl2.PAmt = Convert.ToDouble(row.Cells[5].Value.DefaultZero());
                            gl2.DisP = Convert.ToDouble(row.Cells[6].Value ?? "0");
                            gl2.DisRs = Convert.ToDouble((row.Cells[7].Value ?? "0"));
                            gl2.DisAmt = Convert.ToDouble(Convert.ToDouble(row.Cells[6].Value.DefaultZero()) / 100 * Convert.ToDouble(row.Cells[5].Value.DefaultZero()));//Convert.ToDouble(txtSaleRate.Text);
                            gl2.Debit = 0;
                            gl2.Credit = Convert.ToDouble(row.Cells[8].Value.DefaultZero()); ;
                            db.GL.Add(gl2);
                            db.SaveChanges();

                            GL gl3 = new GL();
                            gl3.RID = sale.RID;
                            gl3.TypeCode = 26;
                            gl3.GLDate = DateTime.Now;
                            gl3.IPrice = item.AveragePrice;
                            gl3.AC_Code = item.AC_Code_Cost;
                            gl3.AC_Code2 = Convert.ToInt32(cmbxvendor.SelectedValue);
                            gl3.Narration = cmbxvendor.SelectedText;
                            //  gl.MOP_ID = 2;
                            gl3.Qty_Out = ctn + Convert.ToInt32(row.Cells[3].Value);
                            gl3.PAmt = Convert.ToDouble(item.AveragePrice.DefaultZero()) * gl1.Qty_Out;//Convert.ToDouble(row.Cells[5].Value.DefaultZero());
                            gl3.DisP = 0;// Convert.ToDouble(row.Cells[6].Value ?? "0");
                            gl3.DisRs = 0; //Convert.ToDouble((row.Cells[7].Value ?? "0"));
                            gl3.DisAmt = 0;// Convert.ToDouble(Convert.ToDouble(row.Cells[6].Value.DefaultZero()) / 100 * Convert.ToDouble(row.Cells[5].Value.DefaultZero()));//Convert.ToDouble(txtSaleRate.Text);
                            gl3.Debit = Convert.ToDouble(item.AveragePrice.DefaultZero()) * gl1.Qty_Out; ;
                            gl3.Credit = 0;
                            db.GL.Add(gl3);
                            db.SaveChanges();

                        }
                        else
                        {
                            GL gl = new GL();
                            gl.RID = sale.RID;
                            gl.TypeCode = 26;
                            gl.GLDate = DateTime.Now;
                            gl.IPrice = Convert.ToDouble(row.Cells[4].Value.DefaultZero());
                            gl.AC_Code = Convert.ToInt32(cmbxvendor.SelectedValue);
                            gl.AC_Code2 = item.AC_Code_Inc;
                            gl.Narration = row.Cells[1].Value.ToString();
                            //  gl.MOP_ID = 2;
                            // var ctnledger = Convert.ToDouble(item.CTN_PCK.DefaultZero()) * Convert.ToDouble(row.Cells[2].Value.DefaultZero());
                            gl.Qty_Out = ctn + Convert.ToInt32(row.Cells[3].Value);
                            gl.PAmt = Convert.ToDouble(row.Cells[5].Value.DefaultZero());
                            gl.DisP = Convert.ToDouble(row.Cells[6].Value ?? "0");
                            gl.DisRs = Convert.ToDouble((row.Cells[7].Value ?? "0"));
                            gl.DisAmt = Convert.ToDouble(Convert.ToDouble(row.Cells[6].Value.DefaultZero()) / 100 * Convert.ToDouble(row.Cells[5].Value.DefaultZero()));//Convert.ToDouble(txtSaleRate.Text);
                            gl.Debit = Convert.ToDouble(row.Cells[8].Value.DefaultZero());
                            gl.Credit = 0;
                            db.GL.Add(gl);
                            db.SaveChanges();

                            GL gl1 = new GL();
                            gl1.RID = sale.RID;
                            gl1.TypeCode = 26;
                            gl1.GLDate = DateTime.Now;
                            gl1.IPrice = Convert.ToDouble(row.Cells[4].Value.DefaultZero());
                            gl1.AC_Code = item.AC_Code_Inc;
                            gl1.AC_Code2 = Convert.ToInt32(cmbxvendor.SelectedValue);
                            gl1.Narration = cmbxvendor.SelectedText;
                            //  gl.MOP_ID = 2;
                            gl1.Qty_Out = ctn + Convert.ToInt32(row.Cells[3].Value);
                            gl1.PAmt = Convert.ToDouble(row.Cells[5].Value.DefaultZero());
                            gl1.DisP = Convert.ToDouble(row.Cells[6].Value ?? "0");
                            gl1.DisRs = Convert.ToDouble((row.Cells[7].Value ?? "0"));
                            gl1.DisAmt = Convert.ToDouble(Convert.ToDouble(row.Cells[6].Value.DefaultZero()) / 100 * Convert.ToDouble(row.Cells[5].Value.DefaultZero()));//Convert.ToDouble(txtSaleRate.Text);
                            gl1.Debit = 0;
                            gl1.Credit = Convert.ToDouble(row.Cells[8].Value.DefaultZero());
                            db.GL.Add(gl1);
                            db.SaveChanges();



                        }
                        if (txtDisfooter.Text != "0")
                        {
                            int customer = Convert.ToInt32(cmbxvendor.SelectedIndex);
                            var Expense = db.COA_D.Where(x => x.AC_Code == 16000001).FirstOrDefault();
                            var customerDetial = db.COA_D.Where(x => x.AC_Code == customer).FirstOrDefault();

                            GL gl = new GL();
                            gl.RID = sale.RID;
                            gl.TypeCode = 26;
                            gl.GLDate = DateTime.Now;
                            //  gl.IPrice = Convert.ToDouble(row.Cells[4].Value.DefaultZero());
                            gl.AC_Code = Expense.AC_Code;
                            gl.AC_Code2 = Convert.ToInt32(cmbxvendor.SelectedValue);
                            gl.Narration = cmbxvendor.SelectedText;
                            //  gl.MOP_ID = 2;
                            // gl.Qty_Out = (item.CTN_PCK ?? 0 * Convert.ToInt32(row.Cells[2].Value)) + Convert.ToInt32(row.Cells[3].Value);
                            // gl.PAmt = Convert.ToDouble(row.Cells[5].Value.DefaultZero());
                            //  gl.DisP = Convert.ToDouble(row.Cells[6].Value ?? "0");
                            //  gl.DisRs = Convert.ToDouble((row.Cells[7].Value ?? "0"));
                            gl.DisAmt = 0;
                            gl.Debit = Convert.ToDouble(txtDisfooter.Text);
                            gl.Credit = 0;
                            db.GL.Add(gl);
                            db.SaveChanges();

                            GL gl1 = new GL();
                            gl1.RID = sale.RID;
                            gl1.TypeCode = 26;
                            gl1.GLDate = DateTime.Now;
                            gl1.IPrice = Convert.ToDouble(row.Cells[4].Value.DefaultZero());
                            gl1.AC_Code = Convert.ToInt32(cmbxvendor.SelectedValue);
                            gl1.AC_Code2 = Expense.AC_Code;
                            gl1.Narration = Expense.AC_Title;
                            //  gl.MOP_ID = 2;
                            // gl1.Qty_Out = (item.CTN_PCK ?? 0 * Convert.ToInt32(row.Cells[2].Value)) + Convert.ToInt32(row.Cells[3].Value);
                            //gl1.PAmt = Convert.ToDouble(row.Cells[5].Value.DefaultZero());
                            //gl1.DisP = Convert.ToDouble(row.Cells[6].Value ?? "0");
                            //gl1.DisRs = Convert.ToDouble((row.Cells[7].Value ?? "0"));
                            //gl1.DisAmt = Convert.ToDouble(Convert.ToDouble(row.Cells[6].Value.DefaultZero()) / 100 * Convert.ToDouble(row.Cells[5].Value.DefaultZero()));//Convert.ToDouble(txtSaleRate.Text);
                            gl1.Debit = 0;
                            gl1.Credit = Convert.ToDouble(txtDisfooter.Text);
                            db.GL.Add(gl1);
                            db.SaveChanges();
                        }
                    }
                }

                var order = db.Lab_M.Where(x => x.RID == sale.RID).FirstOrDefault();
                var list = db.Lab_D.Where(x => x.RID == sale.RID).ToList();
                List<SaleInvoice> orderList = new List<SaleInvoice>();

                int sNO = 1;


                foreach (var itemName in list)
                {
                    SaleInvoice orders = new SaleInvoice();
                    orders.InvoiceID = order.InvNo;
                    orders.Client = db.COA_D.Where(x => x.AC_Code == order.AC_Code).FirstOrDefault().AC_Title;
                    orders.Time = Convert.ToDateTime(order.EDate);

                    //Pending
                    //    orders.SNO = 
                    orders.item = db.Items.Where(x => x.IID == itemName.IID).FirstOrDefault().IName; ;
                    orders.Rate = Convert.ToDecimal(itemName.SalesPriceP);
                    orders.DiscountRs = Convert.ToDecimal(itemName.DisAmt);
                    orders.DiscountPercentage = Convert.ToDecimal(itemName.DisP);
                    orders.Amount = Convert.ToDecimal(itemName.Amt);
                    orders.Ctn = Convert.ToDecimal(itemName.CTN);
                    orders.Pcs = Convert.ToDecimal(itemName.PCS);
                    orders.SNO = sNO;
                    sNO++;
                    //orders.GrossAmt += orders.Rate = Convert.ToDecimal(itemName.SalesPriceP) * Convert.ToDecimal(itemName.Qty);
                    //orders.DiscountTotal += Convert.ToDecimal(itemName.Amt);
                    //orders.Total = item.Rate * item.Qty;
                    //orders.orderType = order.OrderType;
                    //orders.TblID = order.TblID;
                    //orders.Gst = order.GST;
                    //var tbl = db.tbl_Table.Where(x => x.ID == order.TblID).FirstOrDefault();
                    //if (tbl != null)
                    //{
                    //    orders.Tbl = tbl.TableName;
                    //}
                    //orders.WaiterID = order.WaiterID;
                    //orders.item = db.Items.Where(x => x.IID == item.itemID).FirstOrDefault().IName;
                    //orders.booker = "Owais";
                    //orders.CatID = item.CatID ?? 0;
                    //orders.ItemID = item.itemID ?? 0;
                    //orders.Qty = item.Qty;
                    //orders.Rate = item.Rate;
                    //orders.CashCard = Convert.ToDecimal(txtCards2.Text == "" ? "0" : txtCards2.Text);
                    orderList.Add(orders);
                }


                LocalReport localReport = new LocalReport();
                localReport.DataSources.Add(new ReportDataSource("DataSet1", orderList));
                //localReport.ReportPath = "SkyIce.Report1.rdlc";
                localReport.ReportEmbeddedResource = "SalesMngmt.Reporting.Definition.SaleReceiptDisc.rdlc";
                //    C:\Users\hair\Desktop\New folder (5)\Setup\New folder\SalesMgmt\SalesMngmt\Reporting\Definition\SaleReceiptDisc.rdlc

                localReport.PrintToPrinter();
                int mode = Convert.ToInt32(cmbxPaymentMode.SelectedValue);

                int Cashmode = Convert.ToInt32(cmbxAccID.SelectedValue);
                if (mode == 0)
                {



                }
                else if (Cashmode == 1)
                {




                }

                else
                {

                    GL gl = new GL();
                    gl.RID = sale.RID;
                    gl.TypeCode = 5;
                    gl.GLDate = DateTime.Now;
                    // gl.IPrice = Convert.ToDouble(row.Cells[4].Value.DefaultZero());
                    gl.AC_Code = Convert.ToInt32(cmbxPaymentMode.SelectedValue);
                    gl.AC_Code2 = Convert.ToInt32(cmbxvendor.SelectedValue);
                    gl.Narration = cmbxvendor.SelectedText + " has paid cash";//row.Cells[1].Value.ToString();
                    //  gl.MOP_ID = 2;
                    //gl.Qty_Out =// ctnledger + Convert.ToInt32(row.Cells[3].Value);
                    //gl.PAmt = Convert.ToDouble(row.Cells[5].Value.DefaultZero());
                    //gl.DisP = Convert.ToDouble(row.Cells[6].Value ?? "0");
                    //gl.DisRs = Convert.ToDouble((row.Cells[7].Value ?? "0"));
                    //gl.DisAmt = Convert.ToDouble(Convert.ToDouble(row.Cells[6].Value.DefaultZero()) / 100 * Convert.ToDouble(row.Cells[5].Value.DefaultZero()));//Convert.ToDouble(txtSaleRate.Text);
                    gl.Debit = Convert.ToDouble(txtNetAm.Text.DefaultZero());
                    gl.Credit = 0;
                    db.GL.Add(gl);
                    db.SaveChanges();

                    GL gl1 = new GL();
                    gl1.RID = sale.RID;
                    gl1.TypeCode = 5;
                    gl1.GLDate = DateTime.Now;
                    //   gl1.IPrice = item.AveragePrice;
                    gl1.AC_Code = Convert.ToInt32(cmbxvendor.SelectedValue); //item.AC_Code_Inv;
                    gl1.AC_Code2 = Convert.ToInt32(cmbxPaymentMode.SelectedValue);
                    gl1.Narration = cmbxvendor.SelectedText + " has paid cash";
                    //  gl.MOP_ID = 2;
                    //   gl1.Qty_Out = ctnledger + Convert.ToInt32(row.Cells[3].Value);
                    //  gl1.PAmt = Convert.ToDouble(item.AveragePrice.DefaultZero()) * (ctnledger + Convert.ToInt32(row.Cells[3].Value));//Convert.ToDouble(row.Cells[5].Value.DefaultZero());
                    //  gl1.DisP = 0;// Convert.ToDouble(row.Cells[6].Value ?? "0");
                    // gl1.DisRs = 0; //Convert.ToDouble((row.Cells[7].Value ?? "0"));
                    // gl1.DisAmt = 0;// Convert.ToDouble(Convert.ToDouble(row.Cells[6].Value.DefaultZero()) / 100 * Convert.ToDouble(row.Cells[5].Value.DefaultZero()));//Convert.ToDouble(txtSaleRate.Text);
                    gl1.Debit = 0;
                    gl1.Credit = Convert.ToDouble(txtNetAm.Text.DefaultZero());
                    db.GL.Add(gl1);
                    db.SaveChanges();


                }
                transaction.Commit();
                UpdateItemRate();
                MessageBox.Show("Invoice Save Successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                clear();
            }
            catch (Exception ex)
            {
                transaction.Rollback();
                MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void UpdateItemRate()
        {
            //foreach (DataGridViewRow row in invGrid.Rows)
            //{
            //    var check = Convert.ToBoolean(row.Cells["chkRate"].Value);
            //    if (check)
            //    {
            //        var ItemID = Convert.ToInt32(row.Cells[0].Value);
            //        var items = db.Items.Where(x => x.IID == ItemID).FirstOrDefault();
            //        items.SalesPrice = Convert.ToDouble(row.Cells["SaleRate"].Value.DefaultZero());
            //        db.Entry(items).State = EntityState.Modified;
            //        db.SaveChanges();
            //    }
            //}
        }

        private void cmbxAccID_SelectedIndexChanged(object sender, EventArgs e)
        {
            var dsa = Convert.ToInt32(cmbxAccID.SelectedIndex);

            if (dsa >= 1)
            {


                int value = Convert.ToInt32(cmbxAccID.SelectedValue);
                var vendor = db.COA_D.AsNoTracking().Where(x => x.CAC_Code == value).ToList();


                FillCombo(cmbxvendor, vendor, "AC_Title", "AC_Code", 0);
            }
            else if (dsa == 0)
            {

                //   int value = Convert.ToInt32(cmbxAccID.SelectedValue);
                var vendor = db.COA_D.Where(x => x.CAC_Code == 1).ToList();


                FillCombo(cmbxvendor, vendor, "AC_Title", "CAC_Code", 0);

            }


            //if (cmbxAccID.SelectedValue == null)
            //{

            //}
            //else {
            //    cmbxvendor.SelectedValue = cmbxAccID.SelectedValue ?? 0;
            //}
        }

        //MetroFramework.Controls.MetroTextBox lastFocused;
        //private void cmbxItems_Enter(object sender, EventArgs e)
        //{
        //    lastFocused = sender as MetroFramework.Controls.MetroTextBox;
        //}

        private BarCodeListener ScannerListener;
        bool isGrid = false;
        protected override bool ProcessCmdKey(ref Message msg, Keys keyData)
        {
            if (keyData == (Keys.Control | Keys.G))
            {
                isGrid = true;
                return true;
            }
            if (keyData == (Keys.Up) && isGrid == true)
            {
                moveUp();
                return true;
            }
            if (keyData == (Keys.Down) && isGrid == true)
            {
                moveDown();
                return true;
            }

            if (keyData == (Keys.Control | Keys.W))
            {
                txtctn.Focus();
                isGrid = false;
                return true;
            }
            if (keyData == (Keys.Control | Keys.I))
            {
                cmbxItems.Focus();
                isGrid = false;
                return true;
            }
            if (keyData == (Keys.Control | Keys.T))
            {
                isGrid = false;
                return true;
            }
            else if (keyData == (Keys.Delete))
            {
                invGrid.Rows.RemoveAt(invGrid.SelectedRows[0].Index);
                invGrid_SelectionChanged(null, null);
                if (invGrid.Rows.Count > 0)
                {
                    invGrid.Rows[0].Selected = true;
                }
                isGrid = false;
                return true;
            }
            else if (keyData == (Keys.Control | Keys.S))
            {
                SaveRecord(lblRID.Text);
                isGrid = false;
                return true;
            }
            else if (keyData == (Keys.Control | Keys.P))
            {
                SaveRecord(lblRID.Text);
                isGrid = false;
                return true;
            }
            else if (keyData == (Keys.Control | Keys.B))
            {
                txtCode.Focus();
                isGrid = false;
                return true;
            }
            else if (keyData == (Keys.Control | Keys.E))
            {
                metroButton5_Click(null, null);
                isGrid = false;
                return true;
            }
            else if (keyData == (Keys.Control | Keys.Q))
            {
                if (invGrid.Rows.Count > 0)
                {
                    var itemID = invGrid.Rows[invGrid.SelectedRows[0].Index].Cells["itemID"].Value;
                    var Pcs = invGrid.Rows[invGrid.SelectedRows[0].Index].Cells["Pcs"].Value.DefaultZero();
                    lblItemID.Text = itemID.ToString();
                    txtpcs.Text = Pcs;
                    txtpcs.Focus();
                }
                isGrid = false;
                return true;
            }
            else if (keyData == (Keys.Escape))
            {
                clear();
                isGrid = false;
                return true;
            }
            //else if (keyData == (Keys.Tab) && lastFocused != null)
            //{
            //    var item = listItems.Find(x => x.IName.ToLower().Trim() == cmbxItems.Text.ToLower().Trim());
            //    Items_Leave(item, lastFocused);
            //    return true;
            //}
            else if (keyData == (Keys.Enter) && txtCode.Text == "")
            {
                if (dataGridView1.Visible == true)
                {
                    var ID = dataGridView1.SelectedRows[0].Cells[0].Value;
                    var IID = Convert.ToInt32(ID);
                    lblItemID.Text = ID.ToString();
                    dataGridView1.Visible = false;
                    var items = db.Items.Where(x => x.IID == IID).FirstOrDefault();
                    if (items != null)
                    {
                        Items_Leave(items);
                        isGrid = false;
                    }
                }
                //else if (lastFocused != null)
                //{
                //    var ID = dataGridView1.SelectedRows[0].Cells[0].Value;
                //    var IID = Convert.ToInt32(ID);
                //    var items = db.Items.Where(x => x.IID == IID).FirstOrDefault();
                //    if (items != null)
                //    {
                //        txtpcs.Text = txtpcs.Text.DefaultZero() == "0" ? "1" : txtpcs.Text;
                //        txtRate.Text = items.SalesPrice.DefaultZero();
                //        lblItemID.Text = items.IID.ToString();
                //        calculation();
                //        metroButton1_Click(null, null);
                //        isGrid = false;
                //        lastFocused = null;
                //    }
                //}
                return true;
            }
            else if (keyData == (Keys.Enter) && (txtCode.Text != ""))
            {
                String id = txtCode.Text;
                var items = db.Items.Where(x => x.BarcodeNo == id).FirstOrDefault();
                if (items != null)
                {
                    txtpcs.Text = txtpcs.Text.DefaultZero() == "0" ? "1" : txtpcs.Text;
                    txtRate.Text = items.SalesPrice.DefaultZero();
                    lblItemID.Text = items.IID.ToString();
                    calculation();
                    metroButton1_Click(null, null); // Replacw with new 
                                                    //txtCode.Text = "";
                    txtCode.Focus();
                    isGrid = false;
                }
                return true;
            }

            bool res = false;
            if (ScannerListener != null)
            {
                res = ScannerListener.ProcessCmdKey(ref msg, keyData);
            }
            res = keyData == Keys.Enter ? res : base.ProcessCmdKey(ref msg, keyData);
            return res;
        }



        private void metroButton5_Click(object sender, EventArgs e)
        {
            //EditMessageBox messageBox = new EditMessageBox(SInvoice, compID, "SI");
            //messageBox.Show();
        }

        private void txtRate_Leave(object sender, EventArgs e)
        {
            calculation();
            //var itemID = Convert.ToInt32(cmbxItems.SelectedValue);
            //var item = db.Items.Where(x => x.IID == itemID).FirstOrDefault();
            //if (item != null)
            //{
            //    var TotalPcs = (item.CTN_PCK ?? 0 * Convert.ToInt32(txtctn.Text.DefaultZero())) + Convert.ToInt32(txtpcs.Text.DefaultZero());
            //    txtRate.Text = txtRate.Text.DefaultZero() == "0" ? item.SalesPrice.ToString() : txtRate.Text;
            //    var PcsRate = Convert.ToDouble(txtRate.Text.DefaultZero());
            //    var NetAmount = (PcsRate * TotalPcs) - Convert.ToDouble(txtDisc.Text.DefaultZero());
            //    txtDisPer.Text = txtDisPer.Text ?? "0";
            //    var DiscPerc = Convert.ToDouble(txtDisPer.Text.DefaultZero() == "0" ? "1" : "0." + txtDisPer.Text);
            //    NetAmount = NetAmount * (DiscPerc == 1 ? 1 : 1 - DiscPerc);
            //    txtNet.Text = String.Format("{0:0.00}", NetAmount);
            //    TotalPcs = TotalPcs == 0 ? 1 : TotalPcs;
            //    txtPcsRate.Text = String.Format("{0:0.00}", (Convert.ToDouble(txtNet.Text) / TotalPcs));
            //    txtSaleP.Focus();
            //}
        }

        private void txtSaleP_Leave(object sender, EventArgs e)
        {
            calculation();
            //var itemID = Convert.ToInt32(cmbxItems.SelectedValue);
            //var item = db.Items.Where(x => x.IID == itemID).FirstOrDefault();
            //if (item != null)
            //{
            //    var TotalPcs = (item.CTN_PCK ?? 0 * Convert.ToInt32(txtctn.Text.DefaultZero())) + Convert.ToInt32(txtpcs.Text.DefaultZero());
            //    var PcsRate = Convert.ToDouble(txtSaleP.Text.DefaultZero());
            //    TotalPcs = TotalPcs == 0 ? 1 : TotalPcs;
            //    txtSaleRate.Text = String.Format("{0:0.00}", (PcsRate / TotalPcs));
            //    // metroButton1.Focus();
            //}
        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                foreach (DataGridViewRow row in invGrid.Rows)
                {
                    // row.Cells[15].Value = checkBox1.Checked;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Please Try Again", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void txtDisPer_Leave(object sender, EventArgs e)
        {
            calculation();
            //var itemID = Convert.ToInt32(cmbxItems.SelectedValue);
            //var item = db.Items.Where(x => x.IID == itemID).FirstOrDefault();
            //if (item != null)
            //{
            //    var Pcs = (item.CTN_PCK ?? 0 * Convert.ToInt32(txtctn.Text.DefaultZero())) + Convert.ToInt32(txtpcs.Text.DefaultZero());
            //    var Rate = Convert.ToDouble(txtRate.Text.DefaultZero());
            //    Pcs = Pcs == 0 ? 1 : Pcs;
            //    var NetAmount = Rate / Pcs;
            //    txtNet.Text = String.Format("{0:0.00}", NetAmount);
            //    txtNet.Text = (Convert.ToDouble(txtNet.Text.DefaultZero()) - Convert.ToDouble(txtDisc.Text.DefaultZero())).ToString();
            //    txtDisPer.Text = txtDisPer.Text ?? "0";
            //    var DiscPerc = Convert.ToDouble(txtDisPer.Text.DefaultZero() == "0" ? "1" : "0." + txtDisPer.Text);
            //    txtNet.Text = (Convert.ToDouble(txtNet.Text.DefaultZero()) * (DiscPerc == 1 ? 1 : 1 - DiscPerc)).ToString();
            //    txtPcsRate.Text = String.Format("{0:0.0}", item.SalesPrice * (item.CTN_PCK ?? 0 * Convert.ToInt32(txtctn.Text.DefaultZero())));
            //    txtSaleRate.Text = String.Format("{0:0.0}", item.SalesPrice * Convert.ToInt32(txtpcs.Text.DefaultZero()));
            //}
        }

        public void calculation()
        {
            var itemID = ItemID();
            var item = db.Items.Where(x => x.IID == itemID).FirstOrDefault();
            if (item != null)
            {

                if (txtRate.Text == "" || txtRate.Text == "0")
                {

                    txtRate.Text = item.SalesPrice.DefaultZero();
                }
                if (txtDisc.Text == "" || txtDisc.Text == "0")
                {
                    txtDisc.Text = item.DisR.DefaultZero();
                }

                if (txtDisPer.Text == "" || txtDisPer.Text == "0")
                {
                    txtDisPer.Text = item.DisP.DefaultZero();
                }

                if (txtpcs.Text == "" || txtpcs.Text == "0")
                {
                    txtpcs.Text = 1.ToString();

                }


                if (txtctn.Text == "" || txtctn.Text == "0")
                {
                    txtctn.Text = 0.ToString();

                }

                var ctn = (Convert.ToDouble(txtctn.Text.DefaultZero()) * Convert.ToDouble(item.CTN_PCK.DefaultZero()));

                if (ctn == 0)
                {
                    ctn = Convert.ToDouble(txtctn.Text.DefaultZero());
                }
                var ctnValue = (Convert.ToDouble(txtRate.Text.DefaultZero()) * Convert.ToDouble(ctn));

                var pcs = (Convert.ToDouble(txtRate.Text.DefaultZero()) * Convert.ToDouble(txtpcs.Text.DefaultZero()));

                txtNet.Text = (ctnValue + pcs).ToString();

                txtSaleP.Text = (ctnValue + pcs).ToString();

                var DiscPercValue = Convert.ToDouble(Convert.ToDouble(txtDisPer.Text.DefaultZero()) / 100 * Convert.ToDouble(txtNet.Text.DefaultZero()));

                var DiscValue = Convert.ToDouble(txtDisc.Text.DefaultZero());


                txtNet.Text = (Convert.ToDouble(txtSaleP.Text.DefaultZero()) - (DiscPercValue + DiscValue)).ToString();

                // txtSaleP.Text = (Convert.ToDouble(txtRate.Text.DefaultZero()) * Convert.ToDouble(txtpcs.Text.DefaultZero())).ToString();

                txtPcsRate.Text = (Convert.ToDouble(txtRate.Text.DefaultZero()) * Convert.ToDouble(item.CTN_PCK.DefaultZero())).ToString();

                txtSaleRate.Text = (Convert.ToDouble(txtRate.Text.DefaultZero()) * Convert.ToDouble(1)).ToString();

            }
        }

        private void invGrid_KeyDown(object sender, KeyEventArgs e)
        {
            e.Handled = true;
        }

        private void moveUp()
        {
            if (invGrid.RowCount > 0)
            {
                if (invGrid.SelectedRows.Count > 0)
                {
                    int rowCount = invGrid.Rows.Count;
                    int index = invGrid.SelectedCells[0].OwningRow.Index;

                    if (index == 0)
                    {
                        return;
                    }
                    invGrid.ClearSelection();
                    invGrid.Rows[index - 1].Selected = true;
                    SelectedRow(invGrid.Rows[index - 1]);
                }
            }
        }

        private void moveDown()
        {
            if (invGrid.RowCount > 0)
            {
                if (invGrid.SelectedRows.Count > 0)
                {
                    int rowCount = invGrid.Rows.Count;
                    int index = invGrid.SelectedCells[0].OwningRow.Index;

                    if (index == (rowCount - 1)) // include the header row
                    {
                        return;
                    }
                    invGrid.ClearSelection();
                    invGrid.Rows[index + 1].Selected = true;
                    SelectedRow(invGrid.Rows[index + 1]);
                }
            }
        }

        private void moveDown(string Autofill)
        {
            if (dataGridView1.RowCount > 0)
            {
                if (dataGridView1.SelectedRows.Count > 0)
                {
                    int rowCount = dataGridView1.Rows.Count;
                    int index = dataGridView1.SelectedCells[0].OwningRow.Index;

                    if (index == (rowCount - 1)) // include the header row
                    {
                        return;
                    }
                    dataGridView1.ClearSelection();
                    dataGridView1.Rows[index + 1].Selected = true;
                    EnsureVisibleRow(dataGridView1, index);
                }
            }
        }

        private void moveUp(string Autofill)
        {
            if (dataGridView1.RowCount > 0)
            {
                if (dataGridView1.SelectedRows.Count > 0)
                {
                    int rowCount = dataGridView1.Rows.Count;
                    int index = dataGridView1.SelectedCells[0].OwningRow.Index;

                    if (index == 0)
                    {
                        return;
                    }
                    dataGridView1.ClearSelection();
                    dataGridView1.Rows[index - 1].Selected = true;
                }
            }
        }

        private static void EnsureVisibleRow(DataGridView view, int rowToShow)
        {
            if (rowToShow >= 0 && rowToShow < view.RowCount)
            {
                var countVisible = view.DisplayedRowCount(false);
                var firstVisible = view.FirstDisplayedScrollingRowIndex;
                if (rowToShow < firstVisible)
                {
                    view.FirstDisplayedScrollingRowIndex = rowToShow;
                }
                else if (rowToShow >= firstVisible + countVisible)
                {
                    view.FirstDisplayedScrollingRowIndex = rowToShow - countVisible + 1;
                }
            }
        }

        private void SelectedRow(DataGridViewRow dataGridViewRow)
        {

            lblItemID.Text = dataGridViewRow.Cells[0].Value.ToString();
            cmbxItems.Text = dataGridViewRow.Cells[1].Value.DefaultZero();
            txtctn.Text = dataGridViewRow.Cells[2].Value.DefaultZero();
            txtpcs.Text = dataGridViewRow.Cells[3].Value.DefaultZero();
            txtRate.Text = dataGridViewRow.Cells[4].Value.DefaultZero();
            txtDisPer.Text = dataGridViewRow.Cells[6].Value.DefaultZero();
            txtDisc.Text = dataGridViewRow.Cells[7].Value.DefaultZero();
            txtNet.Text = dataGridViewRow.Cells[8].Value.DefaultZero();
            txtSaleP.Text = dataGridViewRow.Cells[9].Value.DefaultZero();
        }

        private void metroButton7_Click(object sender, EventArgs e)
        {
            Products prod = new Products(0);
            prod.Show();
            prod.openForm();
        }

        private void metroButton6_Click(object sender, EventArgs e)
        {

        }

        private void Items_Leave(Lib.Entity.Items item, MetroFramework.Controls.MetroTextBox txtbox = null)
        {
            dataGridView1.Visible = false;
            panel1.Visible = false;
            if (item == null)
            {
                cmbxItems.Focus();
            }
            else
            {
                try
                {
                    cmbxItems.Text = item.IName;
                    txtCode.Text = item.BarcodeNo;
                    txtRate.Text = item.SalesPrice.DefaultZero();
                    txtDisc.Text = item.DisR.DefaultZero();
                    txtDisPer.Text = item.DisP.DefaultZero();
                    txtpcs.Text = 1.ToString();
                    txtctn.Text = 0.ToString();
                    txtNet.Text = (Convert.ToDouble(txtRate.Text.DefaultZero()) * Convert.ToDouble(txtpcs.Text.DefaultZero())).ToString();
                    var DiscPercValue = Convert.ToDouble(Convert.ToDouble(txtDisPer.Text.DefaultZero()) / 100 * Convert.ToDouble(txtNet.Text.DefaultZero()));
                    var DiscValue = Convert.ToDouble(txtDisc.Text.DefaultZero());
                    txtNet.Text = String.Format("{0:0.00}", Convert.ToDouble(txtRate.Text.DefaultZero()) - (DiscPercValue + DiscValue));
                    txtSaleP.Text = (Convert.ToDouble(txtRate.Text.DefaultZero()) * Convert.ToDouble(txtpcs.Text.DefaultZero())).ToString();
                    txtPcsRate.Text = String.Format("{0:0.00}", Convert.ToDouble(txtRate.Text.DefaultZero()) * Convert.ToDouble(item.CTN_PCK.DefaultZero()));
                    txtSaleRate.Text = String.Format("{0:0.00}", Convert.ToDouble(txtRate.Text.DefaultZero()) * Convert.ToDouble(1));

                    if (Convert.ToInt32(cmbxAccID.SelectedValue) == 3 || Convert.ToInt32(cmbxAccID.SelectedValue) == 9)
                    {
                        int Code = Convert.ToInt32(cmbxvendor.SelectedValue);
                        var abc = db.Itemledger.AsNoTracking().Where(x => x.IID == item.IID && x.TypeCode == 5 && x.AC_CODE == Code);
                        if (abc == null)
                        {
                        }
                        else
                        {
                            double quantity = 0;
                            double amt = 0;
                            foreach (Itemledger getledger in abc)
                            {
                                quantity = Convert.ToDouble(getledger.SJ);
                                amt = Convert.ToDouble(getledger.Amt);
                            }
                            lblPreviousPrice.Text = Convert.ToDouble(amt / quantity).ToString();
                        }
                    }
                    txtpcs.Focus();
                    txtbox = null;
                }
                catch (Exception ex)
                {

                }
            }
        }

        private void cmbxItems_Leave_1(object sender, EventArgs e)
        {

        }

        private void txtPcsRate_Leave(object sender, EventArgs e)
        {
            calculation();
        }

        private void txtSaleRate_Leave(object sender, EventArgs e)
        {
            calculation();
        }

        private void cmbxvendor_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (Convert.ToInt32(cmbxAccID.SelectedIndex) != 0)
            {

                if (Convert.ToInt32(cmbxAccID.SelectedValue) == 3)
                {

                    customerLedger();
                }
                else if (Convert.ToInt32(cmbxAccID.SelectedValue) == 9)
                {


                    vendorledger();

                }
            }
        }

        private void btnAddCustomer_Click(object sender, EventArgs e)
        {
            Configs.Customer cus = new Configs.Customer(compID);
            cus.Show();
            cus.customerAdd();
        }

        public void customerLedger()
        {

            int Vendorcode = Convert.ToInt32(cmbxvendor.SelectedValue);

            var previosBalance = db.getCustomerPreviousBalance(DateTime.Now, Vendorcode).FirstOrDefault();
            int a = 1;

            double credit = previosBalance.credit;
            double debit = previosBalance.debit;
            double balance = debit - credit;
            if (balance != 0)
            {
                //var abc = new MyModels.VendorLedger();
                //abc.Credit = (float)credit;
                //abc.Debit = (float)debit;
                //abc.Balance = (float)balance;
                //abc.Naration = "Previous Balance";
                // CategorysDataGridView.Rows.Add(a, "", "", debit, credit, balance, "Previous Balance");
                a++;
            }
            SaleManagerEntities db1 = new SaleManagerEntities();

            var getdata = db.getCustomerLedgerBYDate(DateTime.Now, DateTime.Now, Vendorcode).ToList();//db.getVendorLedgerBYDate(dtTo.Value, dtFrom.Value,;


            var count = getdata.Count();



            for (int b = 0; b < count; b++)
            {
                // var abc = new MyModels.VendorLedger();

                balance = balance - (double)getdata[b].credit;
                balance = balance + (double)getdata[b].debit;

                //getdata[a].abc.Balance = 0;
                //abc.Credit = (float)getdata[a].credit;
                //abc.Debit = (float)getdata[a].debit;
                //abc.GlDate = (DateTime)getdata[a].GLDate;
                //abc.Naration = getdata[a].Narration;
                //abc.Reference = getdata[a].reference;
                //abc.SNO = a;
                //abc.Balance = (float)balance;


                a++;

                //studentList.Add(abc);
            }


            lblAccountBalance.Text = balance.ToString();
        }

        public void vendorledger()
        {


            //CategorysDataGridView.Rows.Add(1, 2, 3, 4, 5, 6, 7);
            int Vendorcode = Convert.ToInt32(cmbxvendor.SelectedValue);

            var previosBalance = db.getVendorPreviousBalance(DateTime.Now, Vendorcode).FirstOrDefault();
            int a = 1;

            double credit = previosBalance.credit;
            double debit = previosBalance.debit;
            double balance = credit - debit;
            if (balance != 0)
            {
                //var abc = new MyModels.VendorLedger();
                //abc.Credit = (float)credit;
                //abc.Debit = (float)debit;
                //abc.Balance = (float)balance;
                //abc.Naration = "Previous Balance";

                a++;
            }
            SaleManagerEntities db1 = new SaleManagerEntities();

            var getdata = db.getVendorLedgerBYDate(DateTime.Now, DateTime.Now, Vendorcode).ToList();//db.getVendorLedgerBYDate(dtTo.Value, dtFrom.Value,;


            var count = getdata.Count();



            for (int b = 0; b < count; b++)
            {
                // var abc = new MyModels.VendorLedger();

                balance = balance + (double)getdata[b].credit;
                balance = balance - (double)getdata[b].debit;

                //getdata[a].abc.Balance = 0;
                //abc.Credit = (float)getdata[a].credit;
                //abc.Debit = (float)getdata[a].debit;
                //abc.GlDate = (DateTime)getdata[a].GLDate;
                //abc.Naration = getdata[a].Narration;
                //abc.Reference = getdata[a].reference;
                //abc.SNO = a;
                //abc.Balance = (float)balance;


                a++;



            }

            lblAccountBalance.Text = balance.ToString();
        }

        class Batches
        {
            public int ID { get; set; }
            public String Name { get; set; }
        }

        private void txtTransportExpense_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar) && (e.KeyChar != '.'))
            {
                e.Handled = true;
            }

            // only allow one decimal point
            if ((e.KeyChar == '.') && ((sender as MetroFramework.Controls.MetroTextBox).Text.IndexOf('.') > -1))
            {
                e.Handled = true;
            }
        }

        private void txtTransportExpense_TextChanged(object sender, EventArgs e)
        {
            txtNetAm.Text = (Convert.ToDouble(txtTotalAm.Text.DefaultZero()) + Convert.ToDouble(txtTransportExpense.Text.DefaultZero()) - Convert.ToDouble(txtDisfooter.Text.DefaultZero())).ToString();
        }

        private void cmbxItems_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Down)
            {
                e.Handled = true; // to prevent system processing
                moveDown("");
                return;
            }
            if (e.KeyCode == Keys.Up)
            {
                e.Handled = true; // to prevent system processing
                moveUp("");
                return;
            }

            if (cmbxItems.Text == "")
            {
                dataGridView1.Visible = false;
                panel1.Visible = false;
                return;
            }
            SqlCommand cmd = new SqlCommand("SP_Items", SqlHelper.DefaultSqlConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Param", SqlDbType.NVarChar).Value = cmbxItems.Text;

            //cmd.Parameters.AddWithValue("@Param", "shahzaib");
            var rows = SqlHelper.ExecuteDataset(cmd).Tables[0];
            var items = rows.ToList<Items>();


            if (items.Count > 0)
            {
                dataGridView1.Visible = true;
                panel1.Visible = true;
                dataGridView1.DataSource = items;
                dataGridView1.Columns["IID"].Visible = false;
                this.dataGridView1.Height = 45 * items.Count;
                panel1.Height = 43 * items.Count;
            }
            else
            {
                dataGridView1.Visible = false;
                panel1.Visible = false;
            }
        }

        private void dataGridView1_PreviewKeyDown(object sender, PreviewKeyDownEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                int i = dataGridView1.CurrentRow.Index;
                MessageBox.Show(i.ToString());
            }
        }

        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex > -1)
            {
                var ItemID = dataGridView1.Rows[e.RowIndex].Cells[0].Value.ToString();
                lblItemID.Text = ItemID;
                var ID = Convert.ToInt16(ItemID);
                var item = listItems.Find(x => x.IID == ID);
                Items_Leave(item);
            }
        }

        private void metroButton1_KeyPress(object sender, KeyPressEventArgs e)
        {

        }

        private void textBox1_Leave(object sender, EventArgs e)
        {
            if (cmbxItems.Text.Trim() != string.Empty)
            {
                var item = listItems.Find(x => x.IName.ToLower().Trim() == cmbxItems.Text.ToLower().Trim());
                Items_Leave(item, null);
            }
        }

        private void txtContactNo_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar) && (e.KeyChar != '.'))
            {
                e.Handled = true;
            }

            // only allow one decimal point
            if ((e.KeyChar == '.') && ((sender as MetroFramework.Controls.MetroTextBox).Text.IndexOf('.') > -1))
            {
                e.Handled = true;
            }
        }

        private void txtContactNo_Leave(object sender, EventArgs e)
        {

            var check = db.Customers.AsNoTracking().Where(x => x.Cell == txtContactNo.Text).ToList();

            if (check.Count == 0 || txtContactNo.Text == "")
            {
                //account headr
                List<COA_M> article = new List<COA_M>();
                article.Add(new COA_M { CAC_Code = 0, CATitle = "--SELECT--" });
                article.AddRange(db.COA_M.AsNoTracking().Where(x => x.CAC_Code == 1 || x.CAC_Code == 3 || x.CAC_Code == 9).ToList());

                FillCombo(cmbxAccID, article, "CATitle", "CAC_Code", 0);


                //parties
                List<COA_D> parties = new List<COA_D>();
                parties.Add(new COA_D { AC_Code = 0, AC_Title = "--Select--" });
                parties.AddRange(db.COA_D.AsNoTracking().Where(x => x.CAC_Code == 1).ToList());
                //   var vendor = ;
                FillCombo(cmbxvendor, parties, "AC_Title", "AC_Code", 0);

            }
            else
            {
                int accode = Convert.ToInt32(check[0].AC_Code);
                var customer = db.COA_D.AsNoTracking().Where(x => x.AC_Code == accode).FirstOrDefault();

                // account headr
                List<COA_M> article = new List<COA_M>();
                article.Add(new COA_M { CAC_Code = 0, CATitle = "--SELECT--" });
                //   article.AddRange(db.COA_M.AsNoTracking().Where(x => x.CAC_Code == customer.CAC_Code));

                FillCombo(cmbxAccID, article, "CATitle", "CAC_Code", 0);


                List<Lib.Entity.Customers> parties = new List<Lib.Entity.Customers>();
                parties.Add(new Lib.Entity.Customers { AC_Code = 0, CusName = "--Select--" });
                parties.AddRange(db.Customers.AsNoTracking().Where(x => x.Cell == txtContactNo.Text).ToList());
                //   var vendor = ;
                FillCombo(cmbxvendor, parties, "CusName", "AC_Code", 0);

                //parties 

                //var employee = new List<Customer>();
                //employee.Add(new Customer { CusName = "Select", AC_Code = 0 });
                //employee.AddRange(db.Customers.Where(x => x.Cell == txtNumber.Text).ToList());
                //FillCombo(cmbxPatient, employee, "CusName", "AC_Code", 0);
            }
        }
    }
    //public class Items
    //{
    //    public int IID { get; set; }
    //    public string ArticleNo { get; set; }
    //    public String IName { get; set; }
    //    public int Color { get; set; }
    //    public int Size { get; set; }
    //    public String Comp { get; set; }

    //    public string Formula { get; set; }


    //}
}