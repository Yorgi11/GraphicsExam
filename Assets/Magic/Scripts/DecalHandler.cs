using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class DecalHandler : MonoBehaviour
{
    Material mat;
    bool show = false;

    private void OnMouseDown()
    {
        show = !show;
        if (show) mat.SetFloat("_ShowDecal", 1);
        else mat.SetFloat("_ShowDecal", 0);
    }
    void Start()
    {
        mat = this.GetComponent<Renderer>().sharedMaterial;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
