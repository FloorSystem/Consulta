package ja_jdbc_plpgsql.jdbc;

import ja_jdbc_plpgsql.bean.bConsulta;
import ja_jdbc_plpgsql.bean.bConsulta2;
import ja_jdbc_plpgsql.bean.bConsultaCompo;
import ja_jdbc_plpgsql.connection.DBConnectionManager;
import java.sql.Statement;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

/**
 *
 * @author psantos
 */
public class jConsultaWeb {

    private static DBConnectionManager conMgr;
    static CallableStatement call;
    static SimpleDateFormat formatt = new SimpleDateFormat("dd/MM/yy HH:mm");

    static {
        conMgr = DBConnectionManager.getInstance();
    }

    //Defeitos Assistec.
    public static ArrayList<bConsulta> getListaProdAssistec(String dt1) throws SQLException, ClassNotFoundException {
        ArrayList<bConsulta> sts = new ArrayList<bConsulta>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            Statement stmt = conPol.createStatement();
            String strQl;
            strQl = "SELECT distinct(tb_assis_tec.cod_prod),tb_produto.str_prod FROM tb_assis_tec,tb_produto  "
                    + "WHERE tb_assis_tec.cod_prod = tb_produto.cod_prod  "
                    + "AND date_trunc('month',  datah) =  TO_timestamp('" + dt1 + "','MM/YYYY') "
                    + "ORDER BY cod_prod;";

            ResultSet rs = stmt.executeQuery(strQl);

            while (rs.next()) {
                bConsulta reg = new bConsulta();
                reg.setCod_prod(rs.getString("cod_prod"));
                reg.setStr_prod(rs.getString("str_prod"));
                sts.add(reg);
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    //Defeitos:
    public static ArrayList<bConsulta> getListaProdDataDef(String dt1) throws SQLException, ClassNotFoundException {
        ArrayList<bConsulta> sts = new ArrayList<bConsulta>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            Statement stmt = conPol.createStatement();
            String strQl;
            strQl = "SELECT distinct(tb_defeito.cod_prod),tb_produto.str_prod FROM tb_defeito,tb_produto  "
                    + "WHERE tb_defeito.cod_prod = tb_produto.cod_prod  "
                    + "AND date_trunc('month',  datahora) =  TO_timestamp('" + dt1 + "','MM/YYYY') "
                    + "ORDER BY cod_prod;";

            ResultSet rs = stmt.executeQuery(strQl);

            while (rs.next()) {
                bConsulta reg = new bConsulta();
                reg.setCod_prod(rs.getString("cod_prod"));
                reg.setStr_prod(rs.getString("str_prod"));
                sts.add(reg);
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList<bConsulta> getListaGMP(String dt1) throws SQLException, ClassNotFoundException {
        ArrayList<bConsulta> sts = new ArrayList<bConsulta>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            Statement stmt = conPol.createStatement();
            String strQl;
            strQl = " SELECT DISTINCT "
                    + "  tb_registro.cod_gmp, "
                    + "  tb_gmp.str_gmp "
                    + " FROM "
                    + "  tb_registro, "
                    + "  tb_gmp "
                    + " WHERE "
                    + "  tb_gmp.cod_gmp = tb_registro.cod_gmp AND "
                    + "  date_trunc('month',  datah) =  TO_timestamp('" + dt1 + "','MM/YYYY') "
                    + " ORDER BY str_gmp; ";

            ResultSet rs = stmt.executeQuery(strQl);

            while (rs.next()) {
                bConsulta reg = new bConsulta();
                reg.setCod_prod(String.valueOf(rs.getInt("cod_gmp")));
                reg.setStr_prod(rs.getString("str_gmp"));
                sts.add(reg);
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }
    
    public static ArrayList<bConsulta> getListaGMP3(String dt1,String dt2) throws SQLException, ClassNotFoundException {
        ArrayList<bConsulta> sts = new ArrayList<bConsulta>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            Statement stmt = conPol.createStatement();
            String strQl;
            strQl = " SELECT DISTINCT "
                    + "  tb_registro.cod_gmp, "
                    + "  tb_gmp.str_gmp "
                    + " FROM "
                    + "  tb_registro, "
                    + "  tb_gmp "
                    + " WHERE "
                    + "  tb_gmp.cod_gmp = tb_registro.cod_gmp AND "
                    + " datah >=  '" + dt1 + " 00:00' "
                    + "AND datah <=  '" + dt2 + " 23:59' "
                    + " ORDER BY str_gmp; ";

            ResultSet rs = stmt.executeQuery(strQl);

            while (rs.next()) {
                bConsulta reg = new bConsulta();
                reg.setCod_prod(String.valueOf(rs.getInt("cod_gmp")));
                reg.setStr_prod(rs.getString("str_gmp"));
                sts.add(reg);
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList<bConsulta> getListaProdData(String dt1, String arg_gmp) throws SQLException, ClassNotFoundException {
        ArrayList<bConsulta> sts = new ArrayList<bConsulta>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            Statement stmt = conPol.createStatement();
            String strQl;

            strQl = "SELECT distinct(tb_registro.cod_prod),tb_produto.str_prod FROM tb_registro,tb_produto  "
                    + "WHERE tb_registro.cod_prod = tb_produto.cod_prod  "
                    + "AND date_trunc('month',  datah) =  TO_timestamp('" + dt1 + "','MM/YYYY') ";
            if (!arg_gmp.equals("")) {
                strQl += " AND cod_gmp = " + arg_gmp;
            }
            strQl += " ORDER BY cod_prod;";

            ResultSet rs = stmt.executeQuery(strQl);

            while (rs.next()) {
                bConsulta reg = new bConsulta();
                reg.setCod_prod(rs.getString("cod_prod"));
                reg.setStr_prod(rs.getString("str_prod"));
                sts.add(reg);
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }
    
public static ArrayList<bConsulta> getListaProdData3(String dt1,String dt2, String arg_gmp) throws SQLException, ClassNotFoundException {
        ArrayList<bConsulta> sts = new ArrayList<bConsulta>();
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            Statement stmt = conPol.createStatement();
            String strQl;

            strQl = "SELECT distinct(tb_registro.cod_prod),tb_produto.str_prod FROM tb_registro,tb_produto  "
                    + "WHERE tb_registro.cod_prod = tb_produto.cod_prod  "
                    + "AND datah >=  '" + dt1 + " 00:00' "
                    + "AND datah <=  '" + dt2 + " 23:59' ";

            if (!arg_gmp.equals("")) {
                strQl += " AND cod_gmp = " + arg_gmp;
            }
            strQl += " ORDER BY cod_prod;";

            ResultSet rs = stmt.executeQuery(strQl);

            while (rs.next()) {
                bConsulta reg = new bConsulta();
                reg.setCod_prod(rs.getString("cod_prod"));
                reg.setStr_prod(rs.getString("str_prod"));
                sts.add(reg);
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList getPesquisa2(String prod, String data_in, Integer gmp) throws SQLException, ClassNotFoundException {
        ArrayList<bConsulta> sts = new ArrayList<bConsulta>();
        Connection conPol = conMgr.getConnection("PD");
        ResultSet rs;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        
        //String[] dataspl = data_in.split("/");
        //data_in = dataspl[1] + "/" + dataspl[2];
        
        try {
            call = conPol.prepareCall("{call sp_consulta2_Totais(?,?,?)}");
            call.setString(1, prod);
            call.setString(2, data_in);
            call.setInt(3, gmp);
            rs = call.executeQuery();

            while (rs.next()) {
                bConsulta reg = new bConsulta();
                //reg.setCod_prod(rs.getString("f1"));
                reg.setDia(rs.getString("f2"));
                reg.setNok(rs.getInt("f3"));
                reg.setOk(rs.getInt("f4"));
                //  reg.setProduzidos(rs.getInt("produzidos"));
                reg.setYield(rs.getFloat("f5"));
                sts.add(reg);
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }
    
    public static ArrayList getPesquisa3(String prod, String data_in, String data_fim, Integer gmp) throws SQLException, ClassNotFoundException {
        ArrayList<bConsulta> sts = new ArrayList<bConsulta>();
        Connection conPol = conMgr.getConnection("PD");
        ResultSet rs;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{call sp_consulta2_totais3(?,?,?,?)}");
            call.setString(1, prod);
            call.setString(2, data_in);
            call.setString(3, data_fim);
            call.setInt(4, gmp);
            rs = call.executeQuery();
            while (rs.next()) {
                bConsulta reg = new bConsulta();
                //reg.setCod_prod(rs.getString("f1"));
                reg.setDia(rs.getString("f2"));
                reg.setNok(rs.getInt("f3"));
                reg.setOk(rs.getInt("f4"));
                //  reg.setProduzidos(rs.getInt("produzidos"));
                reg.setYield(rs.getFloat("f5"));
                
                sts.add(reg);
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList<bConsultaCompo> getPesquisaCompo(String prod, String data_in) throws SQLException, ClassNotFoundException {
        ArrayList<bConsultaCompo> sts = new ArrayList<bConsultaCompo>();
        Connection conPol = conMgr.getConnection("PD");
        ResultSet rs;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{call sp_consulta_componemte(?,?)}");
            call.setString(1, prod);
            call.setString(2, data_in);
            rs = call.executeQuery();

            while (rs.next()) {
                bConsultaCompo reg = new bConsultaCompo();
                reg.setCont(rs.getInt("f1"));
                reg.setCod_prod(rs.getString("f2"));
                reg.setStr_compo(rs.getString("f3"));
                reg.setDescricao1(rs.getString("f4"));

                sts.add(reg);
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }
    
    public static ArrayList<bConsultaCompo> getPesquisaCompoAt(String prod, String data_in) throws SQLException, ClassNotFoundException {
        ArrayList<bConsultaCompo> sts = new ArrayList<bConsultaCompo>();
        Connection conPol = conMgr.getConnection("PD");
        ResultSet rs;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{call sp_consulta_componemteAt(?,?)}");
            call.setString(1, prod);
            call.setString(2, data_in);
            rs = call.executeQuery();

            while (rs.next()) {
                bConsultaCompo reg = new bConsultaCompo();
                reg.setCont(rs.getInt("f1"));
                reg.setCod_prod(rs.getString("f2"));
                reg.setStr_compo(rs.getString("f3"));
                reg.setDescricao1(rs.getString("f4"));

                sts.add(reg);
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList getTotaisMes(Integer gmp) throws SQLException, ClassNotFoundException {
        ArrayList<bConsulta> sts = new ArrayList<bConsulta>();
        Connection conPol = conMgr.getConnection("PD");
        ResultSet rs;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            if (gmp != -1) {
                call = conPol.prepareCall("{call sp_consulta2_media(?)}");
                call.setInt(1, gmp);
            } else {
                call = conPol.prepareCall("{call sp_consulta2_media()}");
            }
            rs = call.executeQuery();

            while (rs.next()) {
                bConsulta reg = new bConsulta();
                //reg.setCod_prod(rs.getString("f1"));
                reg.setDia(rs.getString("f2"));
                reg.setNok(rs.getInt("f3"));
                reg.setOk(rs.getInt("f4"));
                //  reg.setProduzidos(rs.getInt("produzidos"));
                reg.setYield(rs.getFloat("f5"));
                sts.add(reg);
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList getTotaisMes(Integer gmp, String arg_prod) throws SQLException, ClassNotFoundException {
        ArrayList<bConsulta> sts = new ArrayList<bConsulta>();
        Connection conPol = conMgr.getConnection("PD");
        ResultSet rs;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            if (gmp != -1) {
                call = conPol.prepareCall("{call sp_consulta2_media(?,?)}");
                call.setInt(1, gmp);
                call.setString(2, arg_prod);
            } else {
                call = conPol.prepareCall("{call sp_consulta2_media()}");
            }
            rs = call.executeQuery();

            while (rs.next()) {
                bConsulta reg = new bConsulta();
                //reg.setCod_prod(rs.getString("f1"));
                reg.setDia(rs.getString("f2"));
                reg.setNok(rs.getInt("f3"));
                reg.setOk(rs.getInt("f4"));
                //  reg.setProduzidos(rs.getInt("produzidos"));
                reg.setYield(rs.getFloat("f5"));
                sts.add(reg);
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList getTotaisOp() throws SQLException, ClassNotFoundException {
        ArrayList sts = new ArrayList();
        Connection conPol = conMgr.getConnection("PD");
        ResultSet rs;

        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{call sp_op_resumo_semana3()}");

            rs = call.executeQuery();

            while (rs.next()) {

                sts.add("<a href=consultaServ?acao=opsConsultaOp&txt_op=" + rs.getInt("op") + ">" + rs.getInt("op") + "</a> \t"
                        + rs.getDate("data_op") + "\t"
                        + rs.getString("nroserieini") + "\t"
                        + rs.getString("nroseriefim") + "\t"
                        + formatt.format(rs.getTimestamp("dt_min")) + "\t"
                        + formatt.format(rs.getTimestamp("dt_max")) + "\t"
                        + rs.getInt("qtd_op") + "\t"
                        + rs.getInt("cont") + "\t"
                        + rs.getString("item") + "   \t"
                        + formatt.format(rs.getTimestamp("dt_prevista")) + "\t- "
                        + rs.getInt("media") + "     \t"
                        + rs.getFloat("yield") + "%"
                        );
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList getTotaisOpMes(String data_in, Integer gmp, String arg_prod) throws SQLException, ClassNotFoundException {
        ArrayList sts = new ArrayList();
        Connection conPol = conMgr.getConnection("PD");
        ResultSet rs;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        if(data_in.length() > 7){
            data_in = data_in.substring(3);
        }
        try {
            call = conPol.prepareCall("{call sp_op_resumo_mes( ?, ?, ?)}");
            call.setString(1, data_in);
            call.setInt(2, gmp);
            call.setString(3, arg_prod);

            rs = call.executeQuery();

            while (rs.next()) {
                sts.add("<a href=consultaServ?acao=opsConsultaOp&txt_op=" + rs.getInt("op") + ">" + rs.getInt("op") + "</a> \t"
                        + rs.getDate("data_op") + "\t"
                        + rs.getString("nroserieini") + "\t"
                        + rs.getString("nroseriefim") + "\t"
                        + formatt.format(rs.getTimestamp("dt_min")) + "\t"
                        + formatt.format(rs.getTimestamp("dt_max")) + "\t"
                        + rs.getInt("qtd_op") + "\t"
                        + rs.getInt("cont") + "\t"
                        + rs.getString("item") + "\t");
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList getOpOp(String arg_op) throws SQLException, ClassNotFoundException, NumberFormatException {
        ArrayList sts = new ArrayList();
        Connection conPol = conMgr.getConnection("PD");
        ResultSet rs;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{call sp_op_resumo_reg3(?)}");
            call.setInt(1, Integer.valueOf(arg_op));
            rs = call.executeQuery();
            while (rs.next()) {
                sts.add("<a href=consultaServ?acao=opsConsultaOp&txt_op=" + rs.getInt("op") + ">" + rs.getInt("op") + "</a> \t"
                        + rs.getDate("data_op") + "\t"
                        + rs.getString("nroserieini") + "\t"
                        + rs.getString("nroseriefim") + "\t"
                        + formatt.format(rs.getTimestamp("dt_min")) + "\t"
                        + formatt.format(rs.getTimestamp("dt_max")) + "\t"
                        + rs.getInt("qtd_op") + "\t"
                        + rs.getInt("cont") + "\t"
                        + rs.getString("item") + "   \t"
                        + formatt.format(rs.getTimestamp("dt_prevista")) + "\t- "
                        + rs.getInt("media") + "     \t"
                        + rs.getFloat("yield") + "%"
                        );
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList getOpSerial(String arg_serial) throws SQLException, ClassNotFoundException {
        ArrayList sts = new ArrayList();
        Connection conPol = conMgr.getConnection("PD");
        ResultSet rs;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{call sp_op_infoser(?)}");
            call.setString(1, arg_serial.toUpperCase());

            rs = call.executeQuery();

            while (rs.next()) {

                sts.add("<a href=consultaServ?acao=opsConsultaOp&txt_op=" + rs.getInt("op") + ">" + rs.getInt("op") + "</a> \t"
                        + rs.getDate("data_op") + "\t"
                        + rs.getString("nroserieini") + "\t"
                        + rs.getString("nroseriefim") + "\t"
                        + "\t\t\t\t\t\t\t"
                        + rs.getInt("qtd_op") + "\t"
                        + rs.getString("item") + "\t"
                        + rs.getString("descricao"));
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList getSerialResumo(String arg_serial) throws SQLException, ClassNotFoundException {

        SimpleDateFormat sdf3 = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        ArrayList<ja_jdbc_plpgsql.bean.bRegistro> aobj = new ArrayList<ja_jdbc_plpgsql.bean.bRegistro>();
        ArrayList<ja_jdbc_plpgsql.bean.bDefeito> aobjDef = new ArrayList<ja_jdbc_plpgsql.bean.bDefeito>();
        //  jItm jItm = new jItm();
        ArrayList<String> arra = new ArrayList<String>();

        if(arg_serial.length() > 6 ){
            arg_serial = arg_serial.substring(arg_serial.length() - 6);
        }
        
        aobj = jItm.PesquisaFun(arg_serial);

        if (aobj.isEmpty()) {
            arra.add(" ---> Não há registros deste Número de Série.");
        } else {
         //   arra.add("   --> Teste Funcional:");
         //   arra.add(" ");
            for (ja_jdbc_plpgsql.bean.bRegistro c : aobj) {
                arra.add(
                        c.getCod_prod() + "    "
                        + c.getSerial() + "    "
                        + c.getCod_statusS() + "    "
                        + c.getPosto_gmp() + "    "
                        + sdf3.format(c.getDatah()) + "    "
                        + c.getStr_nome() + "    "
                        + c.getComplemento());
            }
        }

        aobjDef = jItm.getDefeitos(arg_serial);
        if (aobjDef.isEmpty()) {
            //
        } else {
            arra.add(" ");
            arra.add("   --> Reparos:");
            arra.add(" ");
            for (ja_jdbc_plpgsql.bean.bDefeito c : aobjDef) {
                arra.add(
                        c.getCod_prod() + "    "
                        + c.getSerial() + "    "
                        + c.getStr_tp_defeito() + "    "
                        + c.getCod_comp() + c.getPos_comp() + "    "
                        + sdf3.format(c.getDatahora()) + "    "
                        + c.getStr_cr_operador() + "    "
                        + c.getTipo_montagem());
            }
        }

        // Assistec:
        ArrayList<ja_jdbc_plpgsql.bean.bAssistecConsulta> ar_ob = new ArrayList<ja_jdbc_plpgsql.bean.bAssistecConsulta>();
        ar_ob = jAssistec2.getSintomas(arg_serial);

        if (ar_ob.isEmpty()) {
            //
        } else {
            SimpleDateFormat formatt1 = new SimpleDateFormat("dd/MM/yy HH:mm:ss");
            arra.add(" ");
            arra.add("   --> Assistec:");
            arra.add(" ");
            for (ja_jdbc_plpgsql.bean.bAssistecConsulta c : ar_ob) {
                arra.add(
                        c.getSerial() + "    "
                        + c.getStr_sintoma() + "    "
                        + c.getTipo_montagem() + ": " + c.getCod_comp() + c.getPos_comp() + "    "
                        + c.getStr_tp_defeito() + "    "
                        + formatt1.format(c.getDatahora()) + "    "
                        + c.getStr_cr_operador() + "    "
                        + c.getCod_deposito() + "    "
                        + c.getObs() + "    "
                        + c.getStr_sa());
            }
        }
        return arra;
    }
    

    public static ArrayList getSerialResumoAssis(String arg_serial) throws SQLException, ClassNotFoundException {


        ArrayList<String> arra = new ArrayList<String>();

        if(arg_serial.length() > 6 ){
            arg_serial = arg_serial.substring(arg_serial.length() - 6);
        }
        
        // Assistec:
        ArrayList<ja_jdbc_plpgsql.bean.bAssistecConsulta> ar_ob = new ArrayList<ja_jdbc_plpgsql.bean.bAssistecConsulta>();
        ar_ob = jAssistec2.getSintomas(arg_serial);

        if (ar_ob.isEmpty()) {
            //
        } else {
            SimpleDateFormat formatt1 = new SimpleDateFormat("dd/MM/yy HH:mm:ss");
           // arra.add(" ");
           //arra.add("   --> Assistec:");
           // arra.add(" ");
            for (ja_jdbc_plpgsql.bean.bAssistecConsulta c : ar_ob) {
                arra.add(
                        c.getSerial() + "    "
                        + c.getStr_sintoma() + "    "
                        + c.getTipo_montagem() + ": " + c.getCod_comp() + c.getPos_comp() + "    "
                        + c.getStr_tp_defeito() + "    "
                        + formatt1.format(c.getDatahora()) + "    "
                        + c.getStr_cr_operador() + "    "
                        + c.getCod_deposito() + "    "
                        + c.getObs() + "    "
                        + c.getStr_sa());
            }
        }
        return arra;
    }

    public static ArrayList getSerialFaltaOp(String arg_op) throws SQLException, ClassNotFoundException, NumberFormatException {
        ArrayList sts = new ArrayList();
        Connection conPol = conMgr.getConnection("PD");
        ResultSet rs;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{call sp_op_serfal(?)}");
            call.setInt(1, Integer.valueOf(arg_op));

            rs = call.executeQuery();

            while (rs.next()) {
                sts.add(rs.getString(1));
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList<bConsulta2> getMediaHoras(String data_in, Integer gmp, String arg_prod) throws SQLException, ClassNotFoundException {
        ArrayList<bConsulta2> sts = new ArrayList();
        Connection conPol = conMgr.getConnection("PD");
        ResultSet rs;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("{call sp_consulta_mediahoras( ?, ?, ?)}");
            call.setString(1, arg_prod);
            call.setString(2, data_in);
            call.setInt(3, gmp);


            rs = call.executeQuery();

            while (rs.next()) {
                bConsulta2 bConsulta2 = new bConsulta2();
                bConsulta2.setData_in(rs.getString("txt"));
                bConsulta2.setPosto(rs.getString("posto"));
                bConsulta2.setCont(rs.getInt("cont"));

                sts.add(bConsulta2);
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList<bConsulta2> getMediaHoras2(String dt1, String dt2, Integer gmp, String arg_prod) throws SQLException, ClassNotFoundException {
        ArrayList<bConsulta2> sts = new ArrayList<bConsulta2>();
        Connection conPol = conMgr.getConnection("PD");
        ResultSet rs;
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            String strQl =
                    "	SELECT "
                    + "	date_trunc('hour',datah)::text as dia,"
                    + "	cod_posto,"
                    + "	count(distinct(serial)) as cont,"
                    + "	tb_operador.str_nome,"
                    + "	tb_gmp.obs"
                    + "	FROM "
                    + "	tb_gmp, "
                    + "	tb_operador, "
                    + "	tb_registro"
                    + "	WHERE"
                    + "	tb_gmp.cod_gmp = tb_registro.cod_gmp "
                    + "	AND  tb_registro.cod_cr = tb_operador.cod_cr"
                    + "	and tb_registro.cod_gmp = ? "
                    + "	and date_trunc('day',  datah) >=  TO_timestamp(?,'dd/MM/YYYY')"
                    + "	and date_trunc('day',  datah) <=  TO_timestamp(?,'dd/MM/YYYY')"
                    + "	AND cod_prod = ?"
                    + "	group by dia,cod_posto, tb_gmp.obs,tb_operador.str_nome"
                    + "	union ("
                    + "	SELECT "
                    + "	date_trunc('hour',datah)::text as dia,"
                    + "	-1 as cod_posto,"
                    + "	count(distinct(serial)) as cont,"
                    + "	 'NOK'::text as str_nome,"
                    + "	tb_gmp.obs"
                    + "	FROM "
                    + "	tb_gmp, "
                    + "	tb_registro"
                    + "	WHERE"
                    + "	cod_status > 0 and"
                    + "	tb_gmp.cod_gmp = tb_registro.cod_gmp "
                    + "	and tb_registro.cod_gmp = ? "
                    + "	and date_trunc('day',  datah) >=  TO_timestamp(?,'dd/MM/YYYY')"
                    + "	and date_trunc('day',  datah) <=  TO_timestamp(?,'dd/MM/YYYY')"
                    + "	AND cod_prod = ?"
                    + "	group by dia, tb_gmp.obs)"
                    + "	ORDER BY dia,cod_posto;";


            call = conPol.prepareCall(strQl);
            call.setInt(1, gmp);
            call.setString(2, dt1);
            call.setString(3, dt2);
            call.setString(4, arg_prod);

            call.setInt(5, gmp);
            call.setString(6, dt1);
            call.setString(7, dt2);
            call.setString(8, arg_prod);

            rs = call.executeQuery();

            while (rs.next()) {
                bConsulta2 reg = new bConsulta2();
                reg.setData_in(rs.getString("dia"));
                reg.setPosto(String.valueOf(rs.getInt("cod_posto")));
                reg.setCont(rs.getInt("cont"));
                reg.setStr_nome(rs.getString("str_nome"));
                reg.setObs(rs.getString("obs"));
                sts.add(reg);
            }
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }
}
