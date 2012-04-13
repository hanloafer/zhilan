import gfx.ActionConfigVO;
import gfx.FrameInfo;
import gfx.GfxConfigModel;
import gfx.GfxGenrater;
import gfx.LayerConfigVO;
import gfx.NumberUtil;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.imageio.ImageIO;


/**
 * @author hanlu.lu
 * 
 * gfx转换工具
 *
 */
public class PngToGFX implements FilenameFilter {
	
	private GfxConfigModel gcm; 
	
	private GfxGenrater gg;

	public PngToGFX() {
		super();
		gg = new GfxGenrater();
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		PngToGFX ptg = new PngToGFX();
		File p = new File("src/dabaodaizou");
		String [] fnames = p.list(ptg);
		
//		BufferedImage [] cutImgs = new BufferedImage[fnames.length];
//		for (int i=0; i<fnames.length; i++) {
//			String string = fnames[i];
////			System.out.println(p.getAbsolutePath());
//			File png = new  File(p.getAbsolutePath() + "\\" + string);
////			System.out.println(png.getAbsolutePath());
//			//BufferedImage cutImg = ptg.pngCutAlphaRect(png);
//			//cutImgs[i] = cutImg;
//		}
//		BufferedImage mergeImg = null;//ptg.mergeBitmapData(cutImgs);
//		try {
//			ImageIO.write(mergeImg, "png", new File("src/cut/" + "merge.png"));
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		
		
		
		
		String assetpath = null;
		String outpath = null;
		if(args.length>0){
			assetpath = args[0];
			outpath = args[1];
		}else{
			assetpath = "E:\\workspace\\WebGame\\Mwo2WebAvatarTool\\launch\\charactor\\role";
			//outpath = "src/out";
			outpath = "E:\\workspace\\WebGame\\ClientAssets\\assets\\avatar\\";
			
		}
		
		new PngToGFX().start(assetpath, outpath);
	}
	
	private void start(String assetpath, String outputPath){
		this.assetFolder = new File(assetpath);
		this.outputFolder = new File(outputPath);
		
		if(!assetFolder.exists() || !assetFolder.isDirectory()){
			System.out.println("[Error] assetFolder : " + assetFolder.getAbsolutePath() + " Not exists! ");
			return;
		}
		if(!outputFolder.exists()){
			outputFolder.mkdirs();
		}
		
		gcm = GfxConfigModel.getInstance();
		gcm.loadConfig("src/roleanimation.xml");
		
		String partNames [] = gcm.getAllLayernames();
		actionNames = gcm.getAllActionNames();
		actions = gcm.getActionNameMap();
		
		for(String layer : partNames){
			genaratePart(layer);
		}
		
		System.out.println(total + " kb");
	}
	
	private File assetFolder;
	private File outputFolder;
	
	private void genaratePart(final String partname){
		System.out.println(partname);
		System.out.println();
		
		File [] files = assetFolder.listFiles(
			new FilenameFilter() {
				
				@Override
				public boolean accept(File arg0, String arg1) {
					// TODO Auto-generated method stub
					return partname.equals(arg1);
				}
				
			}
		);
		if(files.length <= 0){
			System.out.println("[Error] assetFolder : " + assetFolder.getAbsolutePath() + " Not exists part " + partname + "!");
			return;
		}
		File partFile = files[0];
		
		File itemFolders [] = partFile.listFiles(
				new FilenameFilter() {
					
					@Override
					public boolean accept(File dir, String name) {
						// TODO Auto-generated method stub
						try {
							if(name.length() == 3 && Integer.parseInt(name)>0){
								return true;
							}
						} catch (NumberFormatException e) {
							// TODO Auto-generated catch block
							//e.printStackTrace();
							return false;
						}
						return false;
					}
				}
		);
		
		LayerConfigVO layerCfg = gcm.getLayerByName(partname);
		
		for(File itemFolder : itemFolders){
			genarateItem(layerCfg.id, itemFolder);
		}
		System.out.println("---------------------------------------------------");
	}
	
	private HashMap<String, ActionConfigVO> actions = new HashMap<String, ActionConfigVO>();
	private String actionNames [];
	
	
	private void genarateItem(int layerId, File itemFolder){
		int itemId = Integer.parseInt(itemFolder.getName());
		System.out.println(itemId+ ":");
		
//		final String [] actionNames = this.actionNames;
//		File [] actions = itemFolder.listFiles(new FilenameFilter() {
//			
//			@Override
//			public boolean accept(File dir, String name) {
//				// TODO Auto-generated method stub
//				return actionNames;
//			}
//		});
		for(String actionName : actionNames){
			File actionFolder = new File(itemFolder.getAbsolutePath() + "\\" + actionName);
			if(actionFolder.exists()){
				genarateAction(
						layerId, 
						itemId, 
						actionFolder, 
						actions.get(actionName)
					);
			}
		}
		System.out.println();
	}
	
	private void genarateAction(int layerId, int itemId, File actionFolder, ActionConfigVO actionCfg){
		ArrayList<BufferedImage> pngBmps = new ArrayList<BufferedImage>(); 
		int i=0;
		while(true){
			String pngName = NumberUtil.to3String(i) + ".png";
			File png = new File(actionFolder.getAbsolutePath() + "\\" + pngName);
			if(png.exists()){
				try {
					BufferedImage pngBmp = ImageIO.read(png);
//					System.out.println(pngBmp.getPropertyNames());
//					System.out.println(pngBmp.toString());
					pngBmps.add(pngBmp);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}else{
				break;
			}
			i++;
		}
		Object [] imgs = pngBmps.toArray();
		BufferedImage [] bmps = new BufferedImage[imgs.length];
		System.arraycopy(imgs, 0, bmps, 0, imgs.length);
		
		FrameInfo [] frameinfos = gg.imgsCutAlphaRect(bmps);
		BufferedImage mergepng = gg.mergeBitmapData(frameinfos);
		
		String gfxName = gcm.generateTexName(layerId, itemId, actionCfg.id);
		try {
			byte [] gfxData = gg.genarateGfx(frameinfos);
			File gfxfile = new File(outputFolder.getAbsolutePath()  + "\\" + gfxName + ".gfx");
			FileOutputStream fos = new FileOutputStream(gfxfile);
			int offset = 0;
			int len = 1024;
			while(offset < gfxData.length){
				if((gfxData.length - offset) < 1024){
					len = gfxData.length - offset;
				}
				fos.write(gfxData, offset, len);
				offset += len;
			}
			fos.close();
			int size = (int)Math.ceil(gfxfile.length()/1024);
			System.out.println(actionCfg.name + "\t\t\t" + pngBmps.size() + "F\t" + size + " kb");
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
//		if(true){
//			try {
//				
//				File outFile = new File(outputFolder.getAbsolutePath()  + "\\" + gfxName + ".png");
//				ImageIO.write(mergepng, "PNG", outFile);
//				int size = (int)Math.ceil(outFile.length()/1024);
//				System.out.println(actionCfg.name + "\t\t\t" + pngBmps.size() + "F\t" + size + " kb");
//				total+= size;
//			} catch (IOException e) {
//				e.printStackTrace();
//			}
//		}
	}
	
	private long total = 0;
	
//	private void genarateGfx(int layerId, int itemId, int actionId, ){
//		
//	}
	
	

	@Override
	public boolean accept(File dir, String name) {
		if(name.endsWith(".png")){
			return true;
		}else{
			return false;
		}
	}

}

