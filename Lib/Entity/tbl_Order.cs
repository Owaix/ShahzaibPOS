
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------


namespace Lib.Entity
{

    using System;

    public partial class tbl_Order
    {

        public int OrderId { get; set; }

        public string KOTID { get; set; }

        public string OrderNo { get; set; }

        public System.DateTime OrderDate { get; set; }

        public Nullable<bool> isComplete { get; set; }

        public Nullable<decimal> Discount { get; set; }

        public Nullable<decimal> Amount { get; set; }

        public Nullable<int> TblID { get; set; }

        public Nullable<int> WaiterID { get; set; }

        public string OrderType { get; set; }

        public Nullable<decimal> GST { get; set; }

        public Nullable<int> userID { get; set; }

        public string Cat { get; set; }

        public string Address { get; set; }
        public string ItemDetails { get; set; }
        public int CompanyID { get; set; }

    }

}
