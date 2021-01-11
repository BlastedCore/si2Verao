using Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Core.Objects;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;

namespace EF1
{
    class Program
    {
        private static Dictionary<String, HashSet<Parameters>> Specifics = new Dictionary<String, HashSet<Parameters>>();

        private static void Main()
        {
            Console.WriteLine("\n********\nTeste troca de creditoss entre UC's ?(y/n)\n********\n");
            if(Console.ReadLine().Equals("y"))
            Troca.troca();
           
            bool over = false;
            {
                Console.WriteLine("LIST OF AVAILABLE COMMANDS AND THEIR PARAMETERS:\n");
                FillDictionary();
                List<SqlParameter> param = new List<SqlParameter>();

                Console.WriteLine("\n\n\nYOU MAY USE ANY COMMAND FROM THE LIST OF AVAILABLE COMMANDS\n\n");
                while (!over)
                {
                    String temp = Console.ReadLine();
                    if (temp.Equals("over"))
                    {
                        over = true;
                    }

                    if (!temp.Equals("") && !temp.Equals("over"))
                    {
                        Console.WriteLine(Specifics.ContainsKey(temp) ? temp + " exists and can be used" : temp + " is not a valid command ");

                        if (Specifics.ContainsKey(temp))
                        {
                            if (temp.Equals("listMatriculas"))
                            {
                                listMatriculas();
                            }
                            else if (temp.Equals("deleteAlunoAllInfo"))
                            {
                                Console.WriteLine("Please insert the Student Number(4 digits)");
                                temp = Console.ReadLine();
                                deleteAllFromAluno(temp);
                            }
                            else
                            {
                                List<Parameters> l = Specifics[temp].ToList();
                                List<String> x = new List<string>();
                                foreach (Parameters p in l)
                                {
                                    String message = "Insert the value for parameter " + p.name + " the input has the following format(size):" + p.type + "(" + p.length + ")";
                                    Console.WriteLine(message);
                                    String y = Console.ReadLine();


                                    x.Add(y.Equals("") ? null : y);

                                }
                                ExecuteSP(temp, x);
                            }
                            Console.WriteLine("Done.\nPlease insert new command or \"over\" to exit");


                        }
                    }
                }
            }
        }
        private static void FillDictionary()
        {
            var watch = System.Diagnostics.Stopwatch.StartNew();

            List<String> results = new List<string>();
            String getnames = "SELECT name  FROM dbo.sysobjects  WHERE (type = 'P')";
            using (SI2_Fase2Entities db = new SI2_Fase2Entities())
            {
                try
                {
                    int i = 0;
                    var namelist = db.Database.SqlQuery<String>(getnames);
                    foreach (String s in namelist)
                    {
                        results.Add(s);
                        if (s != "sp_noInsc2y" && s != "sp_GetSpecifics" && s != "sp_GetParams" && s != "sp_Catch_errors")
                        {
                            ObjectResult<sp_GetParams_Result> paramlist = db.sp_GetParams(s);
                            if (!paramlist.Equals(null) && s != "sp_noInsc2y" && s != "sp_GetSpecifics")
                            {
                                i++;
                                Console.WriteLine(i + "# " + s);
                                bool hasbeen = false;
                                foreach (sp_GetParams_Result sp in paramlist)
                                {
                                    Console.WriteLine("{0} {1}({2}) {3}", sp.Parameter_name, sp.Type, sp.Length, sp.Param_order);
                                    try
                                    {
                                        if (!hasbeen)
                                        {
                                            Specifics.Add(s, new HashSet<Parameters> { new Parameters(sp.Parameter_name, sp.Type, sp.Length.ToString(), sp.Param_order.ToString()) });
                                            hasbeen = true;
                                        }
                                        else
                                        {
                                            Specifics[s].Add(new Parameters(sp.Parameter_name, sp.Type, sp.Length.ToString(), sp.Param_order.ToString()));
                                        }
                                    }
                                    catch (ArgumentNullException)
                                    {
                                        Console.Write("Something went wrong with the initialization, please restart");
                                    }
                                    catch (ArgumentException)
                                    {
                                        Console.Write("Something went wrong with the initialization, please restart");
                                    }
                                }
                                Console.WriteLine();
                            }
                        }
                    }
                    try
                    {
                        Specifics.Add("listMatriculas", new HashSet<Parameters> { });
                        Console.WriteLine(i++ + "# " + "listMatriculas\n");
                        Specifics.Add("deleteAlunoAllInfo", new HashSet<Parameters> { });
                        Console.WriteLine(i + "# " + "deleteAlunoAllInfo\n@nALuno int(4) 1");
                    }
                    catch (ArgumentException)
                    {
                        Console.WriteLine("Something went wrong with the initialization, please restart");
                    }


                }
                finally
                {
                    db.Dispose();
                }
            }
            watch.Stop();
            var elapsedMs = watch.ElapsedMilliseconds;
            Console.WriteLine("\nmilisseconds to fill Dictionary = " + elapsedMs);

        }
        private static void ExecuteSP(String sp, List<String> param)
        {
            var watch = System.Diagnostics.Stopwatch.StartNew();

            using (var db = new SI2_Fase2Entities())
            {
                try
                {
                    MethodInfo meth = db.GetType().GetMethod(sp);
                    ParameterInfo[] pm = meth.GetParameters();
                    String[] l = param.ToArray();

                    var res = meth.Invoke(db, param.ToArray());
                    if (res.Equals(null))
                    {
                        Console.WriteLine("Something went wrong");
                    }
                    else
                    {
                        Console.WriteLine(res);
                        db.SaveChanges();
                        Console.WriteLine("Operation Complete");
                    }
                }
                catch (SqlException ex)
                {
                    DisplaySqlErrors(ex);                   
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }
                finally
                {
                    db.Dispose();
                    Console.WriteLine("Press any key to continue");
                    Console.ReadKey();
                }
            }
            watch.Stop();
            var elapsedMs = watch.ElapsedMilliseconds;
            Console.WriteLine("\nmilisseconds to run command = " + elapsedMs);


        }
        private static void DisplaySqlErrors(SqlException exception)
        {
            for (int i = 0; i < exception.Errors.Count; i++)
            {
                Console.WriteLine("Error #" + (i + 1) + ": " + exception.Errors[i].ToString() + "\n");
            }
        }
        private static void ReadSingleRow(IDataRecord record)
        {
            Console.WriteLine(String.Format("{0}, {1}", record[0], record[1]));
        }
        private static void listMatriculas()
        {
            var watch = System.Diagnostics.Stopwatch.StartNew();

            using (var db = new SI2_Fase2Entities())
            {
                try
                {

                    DateTime i = DateTime.Now;
                    int year = i.Year;

                    var classes = (from d in db.UCs
                                   select d);
                    foreach (UC u in classes)
                    {
                        var query = (from e in db.Matriculas
                                     from f in db.Inscricaos
                                     from g in db.Ofertas
                                     where f.matricula == e.id &&
                                           e.ano == year &&
                                           g.id == f.oferta &&
                                           g.uc == u.sigla
                                     select e).Count<Matricula>();

                        if (query != 0)
                        {
                            Console.WriteLine("{0}\t{1}", u.sigla, query);
                        }
                    }
                }
                catch (Exception e)
                {

                    Console.WriteLine(e.Message);
                }
                finally
                {
                    db.Dispose();
                    watch.Stop();
                    var elapsedMs = watch.ElapsedMilliseconds;
                    Console.WriteLine("\nmilisseconds to run command = " + elapsedMs);
                    Console.WriteLine("Press any key to continue");
                    Console.ReadKey();
                }
            }
            
        }
        private static void deleteAllFromAluno(String input)
        {
            var watch = System.Diagnostics.Stopwatch.StartNew();

            using (var db = new SI2_Fase2Entities())
            {
                try
                {
                    Int32 num = Int32.Parse(input);
                    db.Alunoes.Remove(db.Alunoes.Single(a => a.nAluno == num));
                    db.SaveChanges();
                }
                catch (Exception e)
                {

                    Console.WriteLine(e.Message.Contains("A sequência não contém elementos") ? "No Student associated with that number" : e.Message);
                }
                finally
                {
                    db.Dispose();
                    Console.WriteLine("Press any key to continue");
                    Console.ReadKey();
                }
            }
            watch.Stop();
            var elapsedMs = watch.ElapsedMilliseconds;
            Console.WriteLine("\nmilisseconds to run command = "+elapsedMs);

        }


    }

    class Parameters
    {
        public string name, type, length, order;
        public Parameters(string name, string type, string length, string order)
        {
            this.name = name;
            this.type = type;
            this.length = length;
            this.order = order;
        }

    }



}

