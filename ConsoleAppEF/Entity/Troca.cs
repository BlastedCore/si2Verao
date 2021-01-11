using System;
using System.Collections.Generic;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Transactions;

namespace Entity
{
    class Troca
    {
        public static void troca()
        {

            using (var ts = new TransactionScope(TransactionScopeOption.Required,
                                              new TransactionOptions { IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted }))
            {
                Console.WriteLine("\n\n\nTeste de troca de Creditos entre PG2 e PG3 \n(Correr codigo sql e seguir instruções no comentario dentro do mesmo)");

                using (var ctx2 = new SI2_Fase2Entities())
                {

                    //troca de creditos entre Mat1 e PG 

                    //inicio
                    try
                    {
                        var pg2 = (from c in ctx2.UCs
                                   where c.sigla == "PG2"
                                   select c).FirstOrDefault();

                        var pg3 = (from c in ctx2.UCs
                                   where c.sigla == "PG3"
                                   select c).FirstOrDefault();


                        //alterar os valores

                        Console.WriteLine("\nvalue found for PG2 = "+pg2.creditos);
                        Console.WriteLine("\nvalue found for PG3 = " + pg3.creditos);

                       
                        Double temp = pg2.creditos; //PONTO - REALIZAR TESTES 
                        pg2.creditos = pg3.creditos;
                        pg3.creditos = temp;

                        ctx2.Database.Log = Console.Write;
                        bool falha;
                        do
                        {

                            Console.WriteLine("STEP ONE");
                            falha = false;
                            try
                            {
                                Console.WriteLine("STEP TWO");
                                ctx2.SaveChanges();
                            }
                            catch (DbUpdateConcurrencyException e)
                            {
                                try
                                {
                                    Console.WriteLine("STEP THREE");

                                    List<DbEntityEntry> entry = e.Entries.ToList<DbEntityEntry>();
                                    foreach (DbEntityEntry d in entry)
                                    {

                                        var dbValues = d.GetDatabaseValues();
                                        d.CurrentValues.SetValues(MergeValues(d.OriginalValues,
                                                                              d.CurrentValues,
                                                                              dbValues));
                                        d.OriginalValues.SetValues(dbValues);
                                        falha = true;
                                    }
                                }
                                catch (Exception i)
                                {
                                    Console.WriteLine("STEP FOUR");
                                    if (i is InvalidCastException)
                                    {
                                        Console.WriteLine(i.Message);
                                    }
                                    else if (i is NullReferenceException)
                                    {
                                        Console.WriteLine("One or more UC's were eliminated mid-transaction");
                                    }
                                    falha = false;
                                }
                            }
                            catch (DbUpdateException e)
                            {
                                Console.WriteLine("STEP FIVE");
                                Console.WriteLine(e.InnerException.InnerException.Message);
                                falha = false;
                            }

                        } while (falha);
                    }
                    //no caso de ser necessário verificar a existencia dos dados iniciais
                    catch (Exception e)
                    {
                        if (e is NullReferenceException || e is InvalidOperationException)
                        {
                            Console.WriteLine("UC no longer exists");
                        }
                    }
                    ts.Complete();
                    Console.WriteLine("\n\n Processo Completo,\n caso deseje recomeçar deve correr o codigo em TesteTroca.sql referente à renovação dos valores iniciais");
                    Console.ReadLine();
                }
            }
        }
        private static DbPropertyValues MergeValues(DbPropertyValues ov, DbPropertyValues cv, DbPropertyValues dbv)
        {
            var rv = cv.Clone(); 
            Console.WriteLine(ov.GetType());
            var delta = ov.GetValue<Double>("creditos") - dbv.GetValue<Double>("creditos");
            rv.SetValues(new { creditos = cv.GetValue<Double>("creditos") - delta });
            return rv;
        }
    }
}
