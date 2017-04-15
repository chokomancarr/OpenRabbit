using UnityEngine;

public class ToonOverlay : MonoBehaviour {

    public Camera tooncam;
    public RenderTexture tex;
    public Material mat;
    public Shader shd;
    [Range(0, 1)]
    public float threshold;
    [Range(-1, 1)]
    public float offset;
    [Range(0, 1)]
    public float ambient;
    [Range(0, 1)]
    public float sharpness;
    [Range(0.0001f, 1)]
    public float darkness;
    [Range(0, 3)]
    public float saturate;
    public bool invertY;

    // Use this for initialization
    void Start () {
        tex = new RenderTexture(Screen.width, Screen.height, 16);
        tooncam.targetTexture = tex;
        mat.SetTexture("_ToonTex", tex);
        //tooncam.SetReplacementShader(shd, "");
    }
	
	void OnRenderImage(RenderTexture src, RenderTexture tar)
    {
        mat.SetFloat("threshold", threshold);
        mat.SetFloat("offset", offset);
        mat.SetFloat("ambient", ambient);
        mat.SetFloat("sharpness", sharpness);
        mat.SetFloat("darkness", darkness);
        mat.SetFloat("saturate", saturate);
        mat.SetFloat("invertY", invertY? 1.0f : 0.0f);
        tooncam.RenderWithShader(shd, "");
        Graphics.Blit(src, tar, mat);
    }
}
