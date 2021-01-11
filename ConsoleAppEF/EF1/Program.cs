using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace EF1
{
    class Program
    {
        private static Dictionary<String, HashSet<Parameters>> Specifics = new Dictionary<String, HashSet<Parameters>>();

        private static void Main()
        {
            bool over = false;
            string connectionString = GetConnectionString();
            if (!isUp(connectionString))
            {
                Console.WriteLine("Server is Unavailable.\nPlease try again at a later date");
            }
            else
            {
                Console.WriteLine("LIST OF AVAILABLE COMMANDS AND THEIR PARAMETERS:\n");
                FillDictionary(connectionString);

                List<SqlParameter> param = new List<SqlParameter>();
                using (var c = new SI2_Fase2Entities())
                {
                    var c1 = (from ct1 in c.Pessoas
                              where ct1.)
                }

                    Console.WriteLine("\n\n\nYOU MAY USE ANY COMMAND FROM THE LIST OF AVAILABLE COMMANDS");
                while (!over)
                {
                    String temp = Console.ReadLine();
                    if (temp.Equals("over")) over = true;
                    if (!temp.Equals("") && !temp.Equals("over"))
                    {
                        Console.WriteLine(Specifics.ContainsKey(temp) ? temp + " exists and can be used" : temp + " is not a valid command ");

                        if (Specifics.ContainsKey(temp))
                        {
                            if (temp.Equals("listMatriculas"))
                            {
                                listMatriculas(connectionString);
                            }
                            else if (temp.Equals("deleteAlunoAllInfo"))
                            {
                                deleteAllFromAluno(connectionString);
                            }
                            else
                            {
                                List<Parameters> l = Specifics[temp].ToList();
                                List<SqlParameter> x = new List<SqlParameter>();
                                foreach (Parameters p in l)
                                {
                                    String message = "Insert the value for parameter " + p.name + " the input has the following format(size):" + p.type + "(" + p.length + ")";
                                    Console.WriteLine(message);
                                    String y = Console.ReadLine();
                                    x.Add(new SqlParameter(p.name, y.Equals("") ? null : y));

                                }
                                ExecuteSP(connectionString, temp, x);
                            }
                            Console.WriteLine("Done.");

                        }
                    }
                }
            }
        }
        private static bool isUp(string connectionString)
        {
            SqlConnection myConnection = new SqlConnection(connectionString);
            if (myConnection != null && myConnection.State == ConnectionState.Closed)
            {
                return false;
            }
            return true;
        }
        private static void FillDictionary(String connectionString)
        {
            List<String> results = new List<string>();
            String getnames = "SELECT name  FROM dbo.sysobjects  WHERE (type = 'P')";
            String getparams = "dbo.sp_GetParams";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                //Create a SqlDataAdapter for the Suppliers table.
                SqlDataAdapter adapter = new SqlDataAdapter();

                // A table mapping names the DataTable.
                adapter.TableMappings.Add("Table", "Results");

                adapter.TableMappings.Clear();

                // Open the connection.
                connection.Open();
                Console.WriteLine("The SqlConnection is open.");

                // Create a SqlCommand to retrieve Suppliers data.
                SqlCommand command = new SqlCommand(
                    getnames,
                    connection);
                command.CommandTimeout = 15;
                command.CommandType = CommandType.Text;

                // Set the SqlDataAdapter's SelectCommand.
                adapter.SelectCommand = command;

                // Fill the DataSet.
                DataSet dataSet = new DataSet("Results");
                adapter.Fill(dataSet);


                int i = 0;
                foreach (DataRow r in dataSet.Tables[0].Rows)
                {

                    String name = r["name"].ToString();
                    results.Add(name);

                    SqlDataAdapter tempadapter = new SqlDataAdapter();
                    tempadapter.TableMappings.Add("Table", "r" + i);
                    SqlCommand tempcommand = new SqlCommand(
                    getparams,
                    connection);
                    tempcommand.Parameters.Add(new SqlParameter("@sp", name));
                    tempcommand.CommandTimeout = 15;
                    tempcommand.CommandType = CommandType.StoredProcedure;
                    tempcommand.ExecuteNonQuery();

                    tempadapter.SelectCommand = tempcommand;
                    DataSet tempdataSet = new DataSet("r" + i);
                    tempadapter.Fill(tempdataSet);
                    if (tempdataSet.Tables.Count > 0 && name != "sp_noInsc2y")
                    {
                        i++;
                        Console.WriteLine(i + "# " + name);
                        foreach (DataRow d in tempdataSet.Tables[0].Rows)
                        {
                            String n = d["Parameter_name"].ToString(), t = d["Type"].ToString(), l = d["Length"].ToString(), o = d["Param_order"].ToString();

                            Console.Write(n + " " + t + "(" + l + ")" + " " + o + "  \n");

                            if (!Specifics.TryAdd(name, new HashSet<Parameters> { new Parameters(n, t, l, o) }))
                            {
                                ((HashSet<Parameters>)Specifics[name]).Add(new Parameters(n, t, l, o));
                            }
                        }
                        Console.WriteLine();
                    }

                }

                // Close the connection.
                connection.Close();
                _ = Specifics.TryAdd("listMatriculas", new HashSet<Parameters> { });
                Console.WriteLine(i + "# " + "listMatriculas\n");
                _ = Specifics.TryAdd("deleteAlunoAllInfo", new HashSet<Parameters> { });
                Console.WriteLine(i + "# " + "deleteAlunoAllInfo\n@nALuno int(4) 1");


                Console.WriteLine("The SqlConnection is closed.");
            }

        }
        private static void SelectAlunos(string connectionString)
        {
            //Create a SqlConnection to the Northwind database.
            using (SqlConnection connection =
                       new SqlConnection(connectionString))
            {
                //Create a SqlDataAdapter for the Suppliers table.
                SqlDataAdapter adapter = new SqlDataAdapter();

                // A table mapping names the DataTable.
                adapter.TableMappings.Add("Table", "Aluno");

                // Open the connection.
                connection.Open();
                Console.WriteLine("The SqlConnection is open.");

                // Create a SqlCommand to retrieve Suppliers data.
                SqlCommand command = new SqlCommand(
                    "SELECT Pessoa.nome, Aluno.nAluno FROM dbo.Aluno,dbo.Pessoa where Aluno.nCont=Pessoa.nCont;",
                    connection);
                command.CommandTimeout = 15;
                command.CommandType = CommandType.Text;

                // Set the SqlDataAdapter's SelectCommand.
                adapter.SelectCommand = command;

                // Fill the DataSet.
                DataSet dataSet = new DataSet("Aluno");
                adapter.Fill(dataSet);


                // Close the connection.
                connection.Close();
                Console.WriteLine("The SqlConnection is closed.");

                foreach (DataRow r in dataSet.Tables[0].Rows)
                {
                    String name = r["nome"].ToString();
                    String num = r["nAluno"].ToString();
                    Console.WriteLine(name + ":" + num);
                }
            }
        }
        private static void ExecuteSP(string connectionString, String sp, List<SqlParameter> param)
        {

            using (SqlConnection connection =
                       new SqlConnection(connectionString))
            {
                connection.Open();
                Console.WriteLine("The SqlConnection is open.");

                SqlTransaction transaction;

                transaction = connection.BeginTransaction(IsolationLevel.RepeatableRead);

                try
                {
                    SqlCommand command = new SqlCommand(
                    sp,
                    connection);

                    command.CommandTimeout = 15;

                    command.CommandType = CommandType.StoredProcedure;
                    if (!param.Equals(null))
                        foreach (SqlParameter s in param)
                        {

                            command.Parameters.Add(s);

                        }
                    SqlDataAdapter adapter = new SqlDataAdapter();

                    command.Connection = connection;

                    command.Transaction = transaction;

                    command.ExecuteNonQuery();

                    adapter.SelectCommand = command;

                    transaction.Commit();

                    DataSet dataSet = new DataSet("Result");

                    adapter.Fill(dataSet);

                    Console.WriteLine("Done.");

                    /*
                                        foreach (DataRow r in dataSet.Tables[0].Rows)
                                        {
                                            String procedure = r["sp"].ToString();
                                            String paramet = r["Parameter_name"].ToString();
                                            String type = r["Type"].ToString();
                                            String len = r["Length"].ToString();
                                            String order = r["Param_order"].ToString();
                                            Console.WriteLine(procedure + ":" + paramet + ":" + type + ":" + len + ":" + order);
                                        }
                    */
                }
                catch (SqlException ex)
                {
                    DisplaySqlErrors(ex);
                    try
                    {
                        transaction.Rollback();
                        Console.WriteLine("Operation Rollback");
                    }
                    catch (Exception ex2)
                    {
                        if (transaction.Connection != null)
                        {
                            Console.WriteLine("Rollback Exception Type: {0}", ex2.GetType());
                            Console.WriteLine("  Message: {0}", ex2.Message);
                        }
                    }

                    Console.WriteLine("Press any key to continue");
                    Console.ReadKey();
                }

            }
        }
        private static string GetConnectionString()
        {
            return ConfigurationManager.AppSettings.Get("Key1");
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
        private static void listMatriculas(string connectionString)
        {
            //Create a SqlConnection to the Northwind database.
            using (SqlConnection connection =
                       new SqlConnection(connectionString))
            {
                //Create a SqlDataAdapter for the Suppliers table.
                SqlDataAdapter adapter = new SqlDataAdapter();

                // A table mapping names the DataTable.
                adapter.TableMappings.Add("Table", "Matriculas");

                // Open the connection.
                connection.Open();
                Console.WriteLine("The SqlConnection is open.");

                // Create a SqlCommand to retrieve Suppliers data.
                SqlCommand command = new SqlCommand(
                    "select t2.uc as UC, matric as Matriculas from(SELECT Oferta,count(oferta) as matric from Inscricao as a join( select id as matricul from Matricula where YEAR(GETDATE())<ano) b on a.matricula=b.matricul  group by oferta)t1 inner join (select id,uc from Oferta )t2 on t1.oferta=t2.id",
                    connection);
                command.CommandTimeout = 15;
                command.CommandType = CommandType.Text;

                // Set the SqlDataAdapter's SelectCommand.
                adapter.SelectCommand = command;

                // Fill the DataSet.
                DataSet dataSet = new DataSet("Matriculas");
                adapter.Fill(dataSet);


                // Close the connection.
                connection.Close();
                Console.WriteLine("The SqlConnection is closed.");

                foreach (DataRow r in dataSet.Tables[0].Rows)
                {

                    String name = r["UC"].ToString();
                    String num = r["Matriculas"].ToString();
                    Console.WriteLine("\n" + name + ":" + num + " matriculas neste ano");
                }
            }
        }
        private static void deleteAllFromAluno(string connectionString)
        {
            //Create a SqlConnection to the Northwind database.
            using (SqlConnection connection =
                       new SqlConnection(connectionString))
            {
                // Open the connection.
                connection.Open();
                Console.WriteLine("The SqlConnection is open.");

                // Create a SqlCommand to retrieve Suppliers data.
                SqlCommand command = new SqlCommand(
                    "select t2.uc as UC, matric as Matriculas from(SELECT Oferta,count(oferta) as matric from Inscricao as a join( select id as matricul from Matricula where YEAR(GETDATE())<ano) b on a.matricula=b.matricul  group by oferta)t1 inner join (select id,uc from Oferta )t2 on t1.oferta=t2.id",
                    connection);
                command.CommandTimeout = 15;
                command.CommandType = CommandType.Text;

                command.ExecuteNonQuery();

                // Close the connection.
                connection.Close();
                Console.WriteLine("The SqlConnection is closed.\n Target student has been eliminated from records");

            }

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
