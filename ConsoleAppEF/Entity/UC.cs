//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Entity
{
    using System;
    using System.Collections.Generic;
    
    public partial class UC
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public UC()
        {
            this.Ofertas = new HashSet<Oferta>();
            this.Registo_Prof_Ano = new HashSet<Registo_Prof_Ano>();
            this.Registo_Regente_Ano = new HashSet<Registo_Regente_Ano>();
        }
    
        public int id { get; set; }
        public string escola { get; set; }
        public string sigla { get; set; }
        public string descricao { get; set; }
        public double creditos { get; set; }
    
        public virtual Escola Escola1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Oferta> Ofertas { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Registo_Prof_Ano> Registo_Prof_Ano { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Registo_Regente_Ano> Registo_Regente_Ano { get; set; }
    }
}
