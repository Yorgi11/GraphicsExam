using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextureGenerator : MonoBehaviour
{
    public ComputeShader TextureShader;
    private RenderTexture _rTexture;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (_rTexture == null)
        {
            _rTexture = new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.ARGB32);
            _rTexture.enableRandomWrite = true;
            _rTexture.Create();

            int kernel = TextureShader.FindKernel("CSMain");
            TextureShader.SetTexture(kernel, "Result", _rTexture);

            TextureShader.SetTexture(0, "Result", _rTexture);

            // 8.0f = num threads
            int workgroupsX = Mathf.CeilToInt(Screen.width/8.0f);
            int workgroupsY = Mathf.CeilToInt(Screen.height / 8.0f);

            TextureShader.Dispatch(kernel, workgroupsX, workgroupsY, 1);
            Graphics.Blit(_rTexture, destination);
        }
    }

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
