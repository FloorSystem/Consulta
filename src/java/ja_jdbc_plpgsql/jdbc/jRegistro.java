package ja_jdbc_plpgsql.jdbc;

import ja_jdbc_plpgsql.bean.bRegistro;
import ja_jdbc_plpgsql.connection.DBConnectionManager;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;

/**
 *
 * @author psantos
 */
public class jRegistro {

    private static DBConnectionManager conMgr;
    static CallableStatement call;

    static {
        conMgr = DBConnectionManager.getInstance();
    }

    //Utilizado na web
    public static int Salvarweb(Integer user, int status, String serial, String gmp) throws ClassNotFoundException, SQLException {
        Connection conPol = conMgr.getConnection("PD");
        int ret;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            if (serial.length() > 6) {
                serial = serial.substring(serial.length() - 6);
            } else if (serial.length() < 6) {
                throw new SQLException("Serial Inválido.");
            }

            call = conPol.prepareCall("{ ? = call sp_registro_insert2(?,?,?,?,'')}");
            call.registerOutParameter(1, Types.INTEGER);
            call.setInt(2, user);
            call.setInt(3, status);
            call.setString(4, serial);
            call.setString(5, gmp);
            call.execute();
            ret = call.getInt(1);
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return ret;
    }

    // sp_registro_insert: Consulta  EAN e Converte  em cod_prod. 
    //Utilizado no Dispositivo de Coleta sem fio.
    public static int Salvar(bRegistro bObj) throws ClassNotFoundException, SQLException {
        Connection conPol = conMgr.getConnection("PD");
        int ret;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{ ? = call sp_registro_insert(?,?,?,?,?,?,?)}");
            call.registerOutParameter(1, Types.INTEGER);
            call.setInt(2, bObj.getCod_cr());
            call.setInt(3, bObj.getCod_status());
            call.setString(4, bObj.getCod_prod());
            call.setString(5, bObj.getSerial());
            call.setString(6, bObj.getPosto_gmp());
            call.setString(7, bObj.getComplemento());
            call.setString(8, bObj.getInspecao());
            call.execute();
            ret = call.getInt(1);
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return ret;
    }

    //Utilizado na Tela de registro.
    public static int SalvarFrame(bRegistro bObj) throws ClassNotFoundException, SQLException {
        Connection conPol = conMgr.getConnection("PD");
        int ret;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{ ? = call sp_registro_insert_frame(?,?,?,?,?,?,?)}");
            call.registerOutParameter(1, Types.INTEGER);
            call.setInt(2, bObj.getCod_cr());
            call.setInt(3, bObj.getCod_status());
            call.setString(4, bObj.getCod_prod());
            call.setString(5, bObj.getSerial());
            call.setString(6, bObj.getPosto_gmp());
            call.setString(7, bObj.getComplemento());
            call.setString(8, bObj.getInspecao());

            call.execute();

            ret = call.getInt(1);

            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return ret;
    }

    public static void SalvarCdata1(bRegistro bObj) throws ClassNotFoundException, SQLException {
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{call sp_registro_insert(?,?,?,?,?,?,?,?)}");
            call.setInt(1, bObj.getCod_cr());
            call.setInt(2, bObj.getCod_status());
            call.setString(3, bObj.getCod_prod());
            call.setString(4, bObj.getSerial());
            call.setString(5, bObj.getPosto_gmp());
            call.setString(6, bObj.getComplemento());
            call.setString(7, bObj.getInspecao());
            call.setString(8, bObj.getDataStr());
            call.execute();
            call.close();

        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
    }

    public static int SalvarCdata2(bRegistro bObj) throws ClassNotFoundException, SQLException {
        Connection conPol = conMgr.getConnection("PD");
        int ret = 0;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{? = call sp_registro_insert(?,?,?,?,?,?,?,?)}");
            call.registerOutParameter(1, Types.INTEGER);
            call.setInt(2, bObj.getCod_cr());
            call.setInt(3, bObj.getCod_status());
            call.setString(4, bObj.getCod_prod());
            call.setString(5, bObj.getSerial());
            call.setString(6, bObj.getPosto_gmp());
            call.setString(7, bObj.getComplemento());
            call.setString(8, bObj.getInspecao());
            call.setString(9, bObj.getDataStr());
            call.execute();
            ret = call.getInt(1);
            call.close();
            return ret;
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
    }

    public static void AtualizarReg(bRegistro bObj, String dt1, String dt2, Integer status1, String cod_prod1) throws SQLException {
        Connection conPol = conMgr.getConnection("PD");
        String strQl;
        Statement stmt;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            stmt = conPol.createStatement();
            strQl = "UPDATE tb_registro SET ";
            if (bObj.getCod_status() > -1 && status1 > -1) {
                strQl = strQl + " cod_status = " + status1;
            }
            if (bObj.getCod_status() > -1 && status1 > -1 && !"".equals(bObj.getCod_prod()) && !cod_prod1.equals("")) {
                strQl = strQl + " , ";
            }

            if (!"".equals(bObj.getCod_prod()) && !cod_prod1.equals("")) {
                strQl = strQl + " cod_prod =  '" + cod_prod1 + "' ";
            }

            strQl = strQl + " WHERE  ";
            if (!bObj.getSerial().equals("0")) {
                strQl = strQl + " serial = '" + bObj.getSerial() + "' AND ";
            }

            if (!"".equals(bObj.getCod_prod()) && !cod_prod1.equals("")) {
                strQl = strQl + " cod_prod =  '" + bObj.getCod_prod() + "' AND ";
            }

            if (bObj.getCod_status() > -1 && status1 > -1) {
                strQl = strQl + " cod_status = " + bObj.getCod_status() + " AND ";
            }

            if (bObj.getCod_cr() > -1) {
                strQl = strQl + " cod_cr = " + bObj.getCod_cr() + " AND ";
            }

            strQl = strQl + " datah BETWEEN TO_timestamp('" + dt1 + "','DD/MM/YYYY HH24:MI:SS') AND TO_timestamp('" + dt2 + "','DD/MM/YYYY HH24:MI:SS');";

            stmt.execute(strQl);

        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }

    }

    public int Excluir(bRegistro bObj, String dt1, String dt2) throws ClassNotFoundException, SQLException {
        int ret = 0;
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{ ? = call sp_registro_del(?,?,?,?,?,?);}");
            call.registerOutParameter(1, Types.INTEGER);
            call.setInt(2, bObj.getCod_cr());
            call.setInt(3, bObj.getCod_status());
            call.setString(4, bObj.getCod_prod());
            call.setString(5, bObj.getSerial());
            call.setString(6, dt1);
            call.setString(7, dt2);

            call.execute();
            ret = call.getInt(1);
            call.close();

        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return ret;
    }

    /*     
     *
     *  Usado na pesquisa da Tela de Registro.
     * 
     */
    public static ArrayList<bRegistro> Pesquisa(Integer arg_cod_cr, String dt1, String dt2) throws SQLException, ClassNotFoundException, ParseException {

        ResultSet rs;
        ArrayList<bRegistro> sts = new ArrayList<bRegistro>();

        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        call = conPol.prepareCall("{call sp_registro_pesq2( ?,?,? )}");

        try {
            call.setInt(1, arg_cod_cr);
            call.setString(2, dt1);
            call.setString(3, dt2);

            rs = call.executeQuery();

            while (rs.next()) {
                bRegistro bRegistro = new bRegistro();
                bRegistro.setCod_cr(rs.getInt("cod_cr"));
                bRegistro.setCod_prod(rs.getString("cod_prod"));
                bRegistro.setCod_status(rs.getInt("cod_status"));
                bRegistro.setComplemento(rs.getString("complemento"));
                bRegistro.setDatah(rs.getTimestamp("datah"));
                bRegistro.setInspecao(rs.getString("inspecao"));
                bRegistro.setPosto_gmp(rs.getString("posto_gmp"));
                bRegistro.setSerial(rs.getString("serial"));
                sts.add(bRegistro);
            }
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList<bRegistro> Pesquisa(bRegistro bObj, String dt1, String dt2) throws SQLException, ClassNotFoundException {
        ArrayList<bRegistro> sts = new ArrayList<bRegistro>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }

        try {
            Statement stmt = conPol.createStatement();
            String strQl = "";

            strQl = "SELECT "
                    + "tb_registro.cod_cr, "
                    + "tb_registro.cod_status, "
                    + "tb_registro.cod_prod, "
                    + "tb_registro.serial, "
                    + "tb_registro.posto_gmp, "
                    + "tb_registro.datah, "
                    + "tb_registro.complemento, "
                    + "tb_registro.inspecao, "
                    + "tb_operador.str_nome, "
                    + "tb_registro.cod_gmp "
                    + " FROM tb_registro,tb_operador WHERE ";
            if (bObj.getCod_cr() > -1) {
                strQl = strQl + "tb_registro.cod_cr = " + bObj.getCod_cr();
                strQl = strQl + " AND ";
            }
            if (bObj.getCod_status() > -1) {
                strQl = strQl + " cod_status = " + bObj.getCod_status();
                strQl = strQl + " AND ";
            }

            if (bObj.getCod_gmp() > -1) {
                strQl = strQl + " cod_gmp = " + bObj.getCod_gmp();
                strQl = strQl + " AND ";
            }

            if (!"".equals(bObj.getCod_prod())) {
                strQl = strQl + " cod_prod =  '" + bObj.getCod_prod() + "'";
                strQl = strQl + " AND ";
            }

            strQl = strQl + " serial LIKE '%" + bObj.getSerial() + "%' "
                    + " AND ";
            // desktop =      //+ " datah BETWEEN TO_timestamp('" + dt1 + "','DD/MM/YYYY HH24:MI:SS') AND TO_timestamp('" + dt2 + "','DD/MM/YYYY HH24:MI:SS')"
            if (dt2.equals("")) {
                strQl = strQl + "date_trunc('month',  datah) =  TO_timestamp('" + dt1 + "','MM/YYYY')";
            } else {
                strQl = strQl + " date_trunc('day',  datah) >=  TO_timestamp('" + dt1 + "','dd/MM/YYYY') AND ";
                strQl = strQl + " date_trunc('day',  datah) <=  TO_timestamp('" + dt2 + "','dd/MM/YYYY') ";
            }

            strQl = strQl + " AND tb_operador.cod_cr = tb_registro.cod_cr "
                    + " ORDER BY datah;";

            ResultSet rs = stmt.executeQuery(strQl);

            while (rs.next()) {
                bRegistro bobj = new bRegistro();
                bobj.setCod_cr(rs.getInt("cod_cr"));
                bobj.setCod_status(rs.getInt("cod_status"));
                bobj.setCod_prod(rs.getString("cod_prod"));
                bobj.setSerial(rs.getString("serial"));
                bobj.setPosto_gmp(rs.getString("posto_gmp"));
                bobj.setDatah(rs.getTimestamp("datah"));
                bobj.setComplemento(rs.getString("complemento"));
                bobj.setInspecao(rs.getString("inspecao"));
                bobj.setStr_nome(rs.getString("str_nome"));
                bobj.setCod_gmp(rs.getInt("cod_gmp"));
                sts.add(bobj);
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public ArrayList<bRegistro> Pesquisa(String strQl) throws SQLException, ClassNotFoundException {
        ArrayList<bRegistro> sts = new ArrayList<bRegistro>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        Statement stmt = conPol.createStatement();
        ResultSet rs = stmt.executeQuery(strQl);

        try {
            while (rs.next()) {
                bRegistro bRegistro = new bRegistro();
                bRegistro.setCod_cr(rs.getInt("cod_cr"));
                bRegistro.setCod_status(rs.getInt("cod_status"));
                bRegistro.setCod_prod(rs.getString("cod_prod"));
                bRegistro.setSerial(rs.getString("serial"));
                bRegistro.setPosto_gmp(rs.getString("posto_gmp"));
                bRegistro.setDataStr(rs.getString("datah"));
                bRegistro.setComplemento(rs.getString("complemento"));
                bRegistro.setInspecao(rs.getString("inspecao"));
                bRegistro.setStr_nome(rs.getString("str_nome"));

                sts.add(bRegistro);
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }
    /* 
    public ResultSetTableModel PesquisaTB(String strQl) throws SQLException, ClassNotFoundException {
    //  ArrayList<bRegistro> sts = new ArrayList<bRegistro>();
    ResultSetTableModel ResultSetTableModel;
    
    Connection conPol = conMgr.getConnection("PD");
    
    if (conPol == null) {
    System.out.println("Numero Maximo de Conexoes Atingida!");
    System.exit(1);
    }
    
    try {
    Statement stmt = conPol.createStatement();
    ResultSet rs = stmt.executeQuery(strQl);
    // while (rs.next()) {
    //modelo.addRow(new Object[]{rs.getString(1), rs.getString(2)});
    //   sts.add(new bRegistro(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getTimestamp(6), rs.getString(7), rs.getString(8), rs.getString(9)));
    //}
    ResultSetTableModel = new ResultSetTableModel(rs);
    } finally {
    if (conPol != null) {
    conMgr.freeConnection("PD", conPol);
    }
    }
    return ResultSetTableModel;
    }
     */

    //usado na importação dimanimca:
    public static Timestamp getDatahMaxPesquisa() throws SQLException, ClassNotFoundException {

        ResultSet rs;
        Timestamp z = null;
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }

        try {
            call = conPol.prepareCall(" SELECT MAX(datah)  FROM tb_registro WHERE inspecao = 'i'; "); //--

            rs = call.executeQuery();

            while (rs.next()) {
                z = rs.getTimestamp(1);
            }

            call.close();

        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return z;
    }

    public static ArrayList getDataRegDesk() throws SQLException, ClassNotFoundException {
        ArrayList<String> sts = new ArrayList();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }

        try {
            Statement stmt = conPol.createStatement();
            String strQl = "SELECT MIN(datah) AS dt_min, "
                    + "MAX(datah) as dt_max "
                    + "FROM tb_registro;";

            ResultSet rs = stmt.executeQuery(strQl);

            Calendar calMin = Calendar.getInstance();
            Calendar calMax = Calendar.getInstance();
            int i = 10;
            while (rs.next()) {

                calMin.setTimeInMillis(rs.getTimestamp("dt_min").getTime());
                calMax.setTimeInMillis(rs.getTimestamp("dt_max").getTime());
                //sts.add("Hoje");
                //sts.add("Ontem");                
                while (calMax.compareTo(calMin) == 1) {
                    sts.add((calMax.get(Calendar.MONTH) + 1) + "/" + calMax.get(Calendar.YEAR));
                    calMax.add(Calendar.MONTH, -1);
                    i--;
                    if (i == 0) {
                        break;
                    }
                }

            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public String getDataReg() throws SQLException, ClassNotFoundException {
        String sts = new String();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            Statement stmt = conPol.createStatement();
            String strQl = "SELECT MIN(datah) AS dt_min, "
                    + "MAX(datah) as dt_max "
                    + "FROM tb_registro;";

            ResultSet rs = stmt.executeQuery(strQl);

            Calendar calMin = Calendar.getInstance();
            Calendar calMax = Calendar.getInstance();

            while (rs.next()) {

                calMin.setTimeInMillis(rs.getTimestamp("dt_min").getTime());
                calMax.setTimeInMillis(rs.getTimestamp("dt_max").getTime());

                while (calMax.compareTo(calMin) == 1) {
                    sts = sts + "<option>" + (calMax.get(Calendar.MONTH) + 1) + "/" + calMax.get(Calendar.YEAR) + "</option>";
                    calMax.add(Calendar.MONTH, -1);
                }
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public String getGeraGMP() throws SQLException, ClassNotFoundException {
        String sts = new String();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            Statement stmt = conPol.createStatement();
            String strQl = "SELECT * FROM tb_gmp; ";
            ResultSet rs = stmt.executeQuery(strQl);
            while (rs.next()) {
                sts = sts + "<option value= " + rs.getInt("cod_gmp") + "> GMP-" + rs.getString("str_gmp") + "</option>";
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public String getGeraGMP2() throws SQLException, ClassNotFoundException {
        String sts = new String();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            Statement stmt = conPol.createStatement();
            String strQl = "SELECT * FROM tb_gmp; ";
            ResultSet rs = stmt.executeQuery(strQl);
            while (rs.next()) {
                sts = sts + "<option value= " + rs.getInt("cod_gmp") + "> GMP-" + rs.getString("str_gmp") + "</option>";
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }
}
