package gfx;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import org.jdom.Attribute;
import org.jdom.DataConversionException;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.ProcessingInstruction;
import org.jdom.Text;
import org.jdom.input.SAXBuilder;
import org.jdom.output.XMLOutputter;

public class GfxConfigModel {
	
	private GfxConfigModel() {
		super();
	}

	public ArrayList<LayerConfigVO> layers = new ArrayList<LayerConfigVO>(); 
	public ArrayList<ActionConfigVO> actions = new ArrayList<ActionConfigVO>();
	
	public String [] getAllLayernames(){
		String [] names = new String[layers.size()];
		for(int i=0; i<layers.size(); i++){
			names[i] = layers.get(i).name;
		}
		return names;
	}
	
	public String [] getAllActionNames(){
		String [] names = new String[actions.size()];
		for(int i=0; i<actions.size(); i++){
			names[i] = actions.get(i).name;
		}
		
		return names;
	}
	
	public HashMap<String, ActionConfigVO> getActionNameMap(){
		HashMap<String, ActionConfigVO> actions = new HashMap<String, ActionConfigVO>();
		for(ActionConfigVO action : this.actions){
			
			actions.put(action.name, action);
		}
		return actions;
	}
	
	public int [] getAllActionIds(){
		int [] names = new int[actions.size()];
		for(int i=0; i<actions.size(); i++){
			names[i] = actions.get(i).id;
		}
		
		return names;
	}
	
	public LayerConfigVO getLayerByName(String name){
		for(int i=0; i<layers.size(); i++){
			if(layers.get(i).name.equals(name)){
				return layers.get(i);
			}
		}
		return null;
	}
	
	/**
	 * 
	 * @param layerId	层级id，如武器层，身体层，技能层
	 * @param itemId	装备物品id，如屠龙刀...
	 * @param animId	动作名称，如跑，攻击...
	 * @param extenal	额外属性，战时没用，保留
	 * @return 			gfx名字
	 * 
	 */		
	public String generateTexName(int layerId,int itemId, int animId){
		String ret = "";
		ret+=(int)(layerId/10);
		ret+=layerId%10;
		ret+=((int)itemId/1000) % 10;
		ret+=((int)itemId/100) % 10;
		ret+=((int)itemId/10) % 10;
		ret+=itemId % 10;
		ret+=((int)animId/100) % 10;
		ret+=((int)animId/10) % 10;
		ret+=animId % 10;
		return ret;
	}
	

	public void loadConfig(String filename) {
		SAXBuilder sb = new SAXBuilder();
		// 创建文档
		Document doc = null;
		try {
			doc = sb.build(new FileInputStream(filename));
		} catch (FileNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (JDOMException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		// 加入一条处理指令
		ProcessingInstruction pi = new ProcessingInstruction("xml-stylesheet",
				"href=\"bookList.html.xsl\" type=\"text/xsl\"");
		// 把这条处理指令，加入文档中
		doc.addContent(pi);
		// 获得这个文档的根元素
		Element root = doc.getRootElement();
		java.util.List ls = root.getChildren();
		// 获得这个根元素的所有子元素(不包含子元素的子元素)，却完全忽略其内容 Iterator i = ls.iterator();
		Iterator i = ls.iterator();
		
		while (i.hasNext()) {
			Element e = (Element) i.next();
			String name = e.getName();
			if(name.equals("Texture")){
				parseLayer(e);
			}else if(name.equals("Anim")){
				parseAction(e);
			}
		}

//		// 得到第一个子元素的子元素，却完全忽略其内容
//		Element book = (Element) ls.get(1);
//		// 给这个子元素添加一条属性，
//		Attribute attr = new Attribute("hot", "true");
//		book.setAttribute(attr);
//		// 获得这个元素的子元素（指定）以及其值
//		Element el2 = book.getChild("author");
//		// 输出这个元素的值
//		System.out.println(el2.getName());
//		// 给这个元素的值改个名字
//		el2.setText("cute");
//		// 再获得这个元素的子元素（指定）
//		Element el3 = book.getChild("price");
//		// 给这个值换个值
//		el3.setText(Float.toString(50.0f));
//		String indent = " ";
//		boolean newLines = true;
//		try {
//			XMLOutputter xml = new XMLOutputter();
//			xml.output(doc, new FileOutputStream("e:\\cute.xml"));
//		} catch (Exception e) {
//			System.out.println(e.getMessage());
//
//		}
	}
	
	private void parseLayer(Element e){
		Iterator i = e.getChildren().iterator();
		while (i.hasNext()) {
			e = (Element) i.next();
			LayerConfigVO layer = new LayerConfigVO();
			try {
				layer.id = e.getAttribute("ID").getIntValue();
				layer.name = e.getAttributeValue("Name");
				layers.add(layer);
			} catch (DataConversionException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	}
	
	private void parseAction(Element e){
		Iterator i = e.getChildren().iterator();
		while (i.hasNext()) {
			e = (Element) i.next();
			ActionConfigVO action = new ActionConfigVO();
			try {
				action.id = e.getAttribute("ID").getIntValue();
				action.name = e.getAttributeValue("Name");
				actions.add(action);
			} catch (DataConversionException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	}
	
	private static GfxConfigModel instace = new GfxConfigModel();
	
	public static GfxConfigModel getInstance(){
		return instace;
	}

}
